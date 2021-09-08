resource "azurerm_linux_virtual_machine_scale_set" "linux_vmss" {
  name                = "linux-vm"
  resource_group_name = azurerm_resource_group.policy.name
  location            = azurerm_resource_group.policy.location
  sku                 = var.vm_size
  instances           = 1
  admin_username      = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  depends_on = [
    azurerm_management_group_policy_assignment.allow_sig_only
  ]

  network_interface {
    name    = "linux-vmss-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.host_sn.id
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # This should be allowed
  source_image_id = var.allowed_source_image_id

  # This should be disallowed because it's not using an allowed image gallery source image
  # source_image_reference {
  #   publisher = var.source_image_publisher
  #   offer     = var.source_image_offer
  #   sku       = var.source_image_sku
  #   version   = var.source_image_version
  # }
}
