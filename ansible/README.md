1. Instalação

1.1 Instalação Ansible UBUNTU

# sudo apt-get install software-properties-common (GCE ja vem instalado)
# sudo apt-add-repository ppa:ansible/ansible
# sudo apt-get update
# sudo apt-get install ansible -y

1.2 Checar versão instalada

# ansible --version
# ansible-playbook --version

2. Inventários

/etc/ansible/hosts

exemplo sem grupo
# cat /etc/ansible/hosts
lab01.test.com
lab02.test.com
lab03.test.com

exemplo com grupo
[loadbalancer]
lb01-test.com

[webservers]
app01-test.com
app02-test.com

[database]
db01-test.com

[ansiblecontrol]
admin-test.com

2.1 Listar todos os servidores 
# ansible --list-hosts all

2.2 Tipo de conexão
[ansiblecontrol]
admin-test.com ansible_connection=local

2.3 Inventário não padrão !hosts
ansible -i servidores-prod --list-hosts all
ansible -i servidores-homol --list-hosts all
ansible -i servidores-dev --list-hosts all

3. Comandos Ansible

Listar hosts

ansible--list-hosts all
ansible --list-hosts "app*"
ansible --list-hosts "lb*"

com negação

ansible --list-hosts \!app*

3.1 Checar a sintaxe dos Playbooks.yml
ansible-playbook playbooks/install-httpd.yml --syntax-check

4. Tasks

Execução de comandos/tarefas.

”
-m MODULE_NAME, –module-name=MODULE_NAME
module name to execute (default=command)
”
Execução em todos os hosts listados em “/etc/ansible/hosts”

# ansible -m ping all
# ansible -m command -a "hostname" all
Execução em um único host.

# ansible -a "echo hello" app-01.com.br

5. Playbook

mkdir /etc/ansible/playbooks

1. HOSTNAME
/etc/ansible/playbooks/hostname.yml
---
   - hosts: all
     tasks:
      - command: hostname
2. DATE
/etc/ansible/playbooks/date.yml
---
   - hosts: all
     tasks:
      - command: date
Execução do playbook

# ansible-playbook hostname.yml
# ansible-playbook date.yml

6. Suporte ao Python3

/etc/ansible/hosts
[ansiblecontrol]
admin-test.com ansible_connection=local

[ansiblecontrol:vars]
ansible_python_interpreter=/usr/bin/python3

7. Instalação Apache, Nginx e Mysql via playbook

---
- hosts: webserver
  become: true
  tasks:
    - name: Instalacao do apache2 e componetes adicionais
      apt: name={{item}} state=present update_cache=yes
      with_items:
        - apache2
        - libapache2-mod-wsgi
        - python-pip
        - python-virtualenv

    - name: Garantir que o Apache seja iniciado
      service: name=apache2 state=started enabled=yes

    - name: habilitar o modulo mod_wsgi
      apache2_module: state=present name=wsgi
      notify: restart apache2
  handlers:
    - name: restart apache2
      service: name=apache2 state=restarted

---
- hosts: loadbalancer
  #"became" Utilizar o sudo
  become: true
  tasks:
  - name: "Instalação do NGINX via APT"
    apt: name=nginx state=present update_cache=yes

  - name: "Nginx started"
    service: name=nginx state=started enabled=yes

---
- hosts: database
  become: true
  tasks:
    - name: "Instalacao do MYSQL SERVER via APT"
      apt: name=mysql-server state=present update_cache=yes
    - name: "MySQL started"
      service: name=mysql state=started enabled=yes






