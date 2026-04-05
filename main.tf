# Create a new tag for the user
resource "digitalocean_tag" "tags" {
  count = 10
  name = var.components[count.index]
}

# Create a new Droplet in nyc3 with the user tag
resource "digitalocean_droplet" "instances" {
  count = 10
  image  = var.image
  name   = "${var.components[count.index]}"-dev
  region = var.region
  size   = var.size
  tags   = [digitalocean_tag.tags[count.index].id]
}

## FIREWALL RULE ALLOW ALL FOR THE USER

resource "digitalocean_firewall" "firewallrecords" {
  name = "${var.components[count.index]}-fw"
  count = 10

  droplet_ids = [digitalocean_droplet.instances[count.index].id]

  inbound_rule {
    protocol         = var.protocol
    port_range       = var.port_range
    source_addresses = var.source_address
  }

  outbound_rule {
    protocol              = var.protocol
    port_range            = var.port_range
    destination_addresses = var.destination_addresses
  }
}