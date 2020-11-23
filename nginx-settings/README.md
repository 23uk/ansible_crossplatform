Role Name
=========

nginx-settings

Role Variables
--------------

defaults:
 nginx_log_folder_remote: /var/log/nginx
 nginx_config_remote: /etc/nginx
 virtual_hosts_folder_remote: /etc/nginx/conf.d
 site_folder_remote: /home

Example Playbook
----------------

- name: Install Nginx
  hosts: all
  become: yes

  roles:
    - nginx-settings

