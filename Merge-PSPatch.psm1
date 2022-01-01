<#
    .SYNOPSIS
    Merge-PSPatch - Apply a PSPatcher patch to a binary

    .DESCRIPTION
    This is the main Cmdlet for the PSPatcher module, it is used to apply the PSP File
    based patch to a binary.  See the GitHub ReadMe for more info.

    Requires Module - PsIni which can be installed from the PowerShell Gallery

    Written by CPNXP 2022

    .PARAMETER PSPFile
    Path to the PSPFile to use for the patching process

    .PARAMETER SkipValidation
    Skips checking the SHA256 start and end hashes. This is a bad idea, don't do it.

    .PARAMETER OrigFile
    The orignal file, the file you are patching

    .PARAMETER DestFile
    The output file, if you default this param or make it equal to the OrigFile the OrigFile
    will be renamed with a .backup extention

    .EXAMPLE
    Merge-PSPatch -PSPFile .\patch.psp -OrigFile .\Game.exe
    Applies the patch defined in patch.psp to Game.exe

    .EXAMPLE
    PowerShell will number them for you when it displays your help text to a user.
#>
#Requires -Modules PsIni
Import-Module -Name PsIni
function Merge-PSPatch
{  
  [CmdletBinding()]
  Param
  (
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]$PSPFile,
    [Parameter(Mandatory=$false)][Switch]$SkipValidation=$false,
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]$OrigFile,
    [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]$DestFile=$OrigFile
  )
    
  Process
  {
    $ErrorActionPreference = 'Stop'
    $PSPConf = $null
    $OrigHash = $null
    $NewHash = $null
    
    if(-Not (Test-Path -Path $PSPFile))
    {
      Write-Error -Message 'PSP file path not valid'
      Exit 1
    }
    
    if(-Not (Test-Path -Path $OrigFile))
    {
      Write-Error -Message 'Orignal file path not valid'
      Exit 1
    }
    
    if(-Not (Test-Path -Path $DestFile -IsValid))
    {
      Write-Error -Message 'Destination file path not valid'
      Exit 1
    }
      
    try
    {
      $PSPConf = Get-IniContent -FilePath $PSPFile
      Write-Output -InputObject ('Patch Name: {0}' -f $PSPConf.metadata.name)
      Write-Output -InputObject ('Orignal SHA256: {0}' -f $PSPConf.checksum.original)
    }
    catch
    {
      Write-Error -Message 'Malformed PSP file'
      Exit 1
    }
    
    #TODO: Better validation of PSP file before start
    
    if($SkipValidation)
    {
      Write-Warning -Message "SkipValidation: This is a really bad idea and it probably won't work, you have been warned"
    }
    else
    {
      $OrigHash = Get-FileHash -Path $OrigFile -Algorithm SHA256
    }
    
    if(-Not $SkipValidation)
    {
      if($OrigHash.Hash -ne $PSPConf.checksum.original)
      {
        Write-Error -Message 'Original Binary Hashs do not match!  Aborting.  Did you target the wrong binary or patch?'
        Exit 1
      }
      
      Write-Output -InputObject 'Hashs match - Moving to patching phase'
    }
    
    [byte[]]$rawbytes = Get-Content -Path $OrigFile -Encoding Byte -Raw
    
    if($OrigFile -eq $DestFile)
    {
      $NewName = Split-Path $OrigFile -leaf
      $NewName = "$NewName.backup"
      Rename-Item -Path $OrigFile -NewName $NewName
      Write-Output -InputObject "$OrigFile backed up to $NewName"
    }
    
    Foreach($edit in $PSPConf.hexedit.GetEnumerator())
    {
      $offset = [Convert]::ToInt32($edit.Name, 16)
      $NewByte = [Convert]::ToInt32($edit.Value, 16)
      $OrigByte = $rawbytes[$offset]
      $rawbytes[$offset] = [byte]$NewByte
      Write-Output -InputObject ('Byte at Offset 0x{0} set from 0x{1} to 0x{2}' -f $offset.ToString('X'),$OrigByte.ToString('X2'),$NewByte.ToString('X2'))
    }
    
    Write-Output -InputObject 'Writing out file, this could take awhile for large files...'
    
    $rawbytes | Set-Content -Path $DestFile -Encoding Byte
    
    if(-Not $SkipValidation)
    {
      $NewHash = Get-FileHash -Path $DestFile -Algorithm SHA256
      if($NewHash.Hash -eq $PSPConf.checksum.patched)
      {
        Write-Output -InputObject 'Final Hashs Match: Patching Successful'
      }
      else
      {
        Write-Output -InputObject ("`nDesired:{0}`nActual:{1}`n" -f $PSPConf.checksum.patched,$NewHash.Hash)
        Write-Error -Message 'Final Hash Mismatch'
      }
    }
    else
    {
      Write-Output -InputObject 'Done, validation was disabled'
    }
  }
}
Export-ModuleMember -Function 'Merge-PSPatch'