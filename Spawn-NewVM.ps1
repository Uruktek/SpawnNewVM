# # First time running will will prompt for information
$_FilePath = '.\config.json'#File path where the config should exist

# Make the assumption that it will always be a new VM being spawned and not editing a new one.
# If you're wanting to use an existing VHD rather than making one when running the script
# NewVHD needs to be replaced with VHDpath

#TODO:
# -Computername is a field that can be used this was going to use invokecommand this needs to be added
# Filter out some of the request as some of them can seem pointless if we make the
# assumption that this will always be a new vm being created.
# like the storage location shouldnt be changing nor should the vhdpath
# Construct this like a mod so it can be imported and take params (Do this once it's functional)

if (Test-Path -Path $_FilePath -PathType Leaf) {
    $_SavedInfo = Get-Content $_FilePath | Out-String | ConvertFrom-Json
    #$_Name = $_SavedInfo.name May want this to be asked every time
    $_MemoryStartupBytes = $_SavedInfo.MemoryStartupBytes
    $_BootDevice = $_SavedInfo.BootDevice
    $_NewVHDPath = $_SavedInfo.NewVHDPath 
    $_Path = $_SavedInfo.Path
    $_Generation = $_SavedInfo.Generation
    $_Switch = $_SavedInfo.Switch
    Write-Host $_MemoryStartupBytes $_BootDevice $_NewVHDPath $_Path $_Generation $_Switch
    #Once the vm is created if you're booting from an iso you'll need to add a "dvd drive" add-vmdvddrive
    #Example
    #add-vmdvddrive -vmname name -Path C:\Path\to\boot.iso
}
else {
    $_Name = Read-Host 'What is the vm name? E.G Win10-thing-thing?'
    $_MemoryStartupBytes = Read-Host 'What is the startup memory? E.G 4gb'
    $_BootDevice = Read-host 'What is the boot device?'
    $_NewVHDPath = Read-Host 'Path where the VHD lives? E.G C:\HyperV\VHDs'
    $_Path = Read-host 'Config location for this vm? E.G C:\hyperV\VMConfig'
    $_Generation = Read-Host 'What generation is this vm? Most are Gen 2 if beyond 2008 r2. Use G1 if not windows'
    $_Switch = Read-Host 'What virtual switch is this connecting to? E.G Link 1'
    # Making a custom PSObject to export to json to save for future use

    $_CustomSaveInfo = [PSCustomObject]@{
        Name = $_Name
        MemoryStartupBytes = $_MemoryStartupBytes
        BootDevice = $_BootDevice
        NewVHDPath = $_NewVHDPath
        Path = $_Path
        Generation = $_Generation
        Switch = $_switch
    }

    ConvertTo-Json -InputObject $_CustomSaveInfo | Out-File -FilePath ".\config.json"
}


# function Get-FromSavedJson($filePath){
#     if (Test-Path -Path $filePath -PathType Leaf) {
#         $_SavedConfig = Get-Content $filePath | Out-String | ConvertFrom-Json
#     }
# }

# Write-host 'If this is your first time running you will be asked a few questions.'
# Write-host 'If you need to change any answer there will be an ini file that you can change within the root of the script folder'

# $_CheckForConfig = Test-Path -Path .\config.ini -PathType Leaf
# if ($_CheckForConfig) {
#     Write-host 'Beep'
# }

# {
# 	"name": "w10-test-test",
# 	"MemoryStartupBytes": 4096,
# 	"BootDevice": "VHD",
# 	"NewVHDPath": "C:\\users\\thing",
# 	"Path": "C:\\users\\thing",
# 	"Generation": "2",
# 	"Switch": "DAC Link"
# }