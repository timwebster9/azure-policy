resource "azurerm_windows_virtual_machine_scale_set" "windows_vmss" {
  name                = "windows-vmss"
  resource_group_name = azurerm_resource_group.policy.name
  location            = azurerm_resource_group.policy.location
  sku                 = var.vm_size
  instances           = 2
  admin_username      = "azureuser"
  admin_password      = "sdafasdfsaghdgkjhIOU897£"
  upgrade_mode        = "Automatic"
  
  depends_on = [
    azurerm_management_group_policy_assignment.policy_assignment_windows_vmss
  ]

  network_interface {
    name    = "windows-vmss-nic"
    primary = true

    ip_configuration {
      name      = "windows-vm-ipconfig"
      primary   = true
      subnet_id = azurerm_subnet.host_sn.id
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
