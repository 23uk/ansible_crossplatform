data "hcloud_ssh_key" "devops" {
  name = "REBRAIN.SSH.PUB.KEY"
}

resource "hcloud_ssh_key" "asduk_key" {
  name       = "asduk_key"
  public_key = file(var.asduk_key)
}

data "hcloud_server" "serverinfo" {
  id = hcloud_server.devops_23uk.id
}

resource "hcloud_server" "devops_23uk" {
  image    = "debian-9"
  name     = "devops-23uk"
  server_type = "cx11"
  labels = {
    module = "devops"
    email  = "23uk_at_tut_by"
  }

  location   = "fsn1"
  ssh_keys =  [data.hcloud_ssh_key.devops.id,hcloud_ssh_key.asduk_key.id]

provisioner "local-exec" {
     command = <<EOF
echo --- > host.yml
echo all: >> host.yml
echo " children:" >> host.yml
echo "  rebrain:" >> host.yml
echo "   hosts:" >> host.yml
echo "    ANS01:" >> host.yml
echo "     ansible_host: 23uk.devops.rebrain.srwx.net" >> host.yml
echo "   vars:" >> host.yml
echo "    ansible_user: root" >> host.yml
echo "    ansible_ssh_private_key_file: ./.ssh/id_rsa" >> host.yml

echo --- > playbook.yml
echo "- name: Install Nginx" >> playbook.yml
echo "  hosts: all" >> playbook.yml
echo "  become: yes" >> playbook.yml
echo "  tasks:" >> playbook.yml
echo "  - name: Install epel-release" >> playbook.yml
echo "    yum: name=epel-release state=latest \n" >> playbook.yml
echo "  - name: Install Nginx" >> playbook.yml
echo "    yum: name=nginx state=latest \n" >> playbook.yml
echo "  - name: Autostart webserver" >> playbook.yml
echo "    service: name=nginx state=started enabled=yes" >> playbook.yml

EOF
    }
  
}

data "aws_route53_zone" "dns" {
  name         = "devops.rebrain.srwx.net."
  private_zone = false
}

resource "aws_route53_record" "dns_rebrain" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = "23uk.devops.rebrain.srwx.net"
  type    = "A"
  ttl     = "30"
  records = [data.hcloud_server.serverinfo.ipv4_address]
}

output "server_ip" {
  value = data.hcloud_server.serverinfo.ipv4_address
}

output "aws_route53_zone" {
  value = data.aws_route53_zone.dns.zone_id
}
