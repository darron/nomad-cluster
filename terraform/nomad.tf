provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "bootstrap" {
    ami = "${var.image_id}"
    instance_type = "t1.micro"
    security_groups = ["${aws_security_group.nomad.name}"]
    key_name = "${var.key_name}"

    tags {
      Name = "nomad-bootstrap"
    }

    connection {
      user = "ubuntu"
      key_file = "${var.key_path}"
    }

    provisioner "remote-exec" {
    scripts = [
        "./bootstrap.sh"
      ]
    }
}

resource "aws_instance" "server1" {
    ami = "${var.image_id}"
    instance_type = "t1.micro"
    security_groups = ["${aws_security_group.nomad.name}"]
    key_name = "${var.key_name}"

    tags {
      Name = "nomad-server1"
    }

    connection {
      user = "ubuntu"
      key_file = "${var.key_path}"
    }

    provisioner "remote-exec" {
    inline = [
        "echo ${aws_instance.bootstrap.private_dns} > /tmp/nomad-server-addr"
      ]
    }

    provisioner "remote-exec" {
    scripts = [
        "./bootstrap.sh",
        "./join.sh"
      ]
    }
}

resource "aws_instance" "server2" {
    ami = "${var.image_id}"
    instance_type = "t1.micro"
    security_groups = ["${aws_security_group.nomad.name}"]
    key_name = "${var.key_name}"

    tags {
      Name = "nomad-server2"
    }

    connection {
      user = "ubuntu"
      key_file = "${var.key_path}"
    }

    provisioner "remote-exec" {
    inline = [
        "echo ${aws_instance.bootstrap.private_dns} > /tmp/nomad-server-addr"
      ]
    }

    provisioner "remote-exec" {
    scripts = [
        "./bootstrap.sh",
        "./join.sh"
      ]
    }
}
