#!/bin/bash
(
LOCALE=${1:-en}

export AUTO_BRANCH=${AUTO_BRANCH:-trunk}
export RTC_TEAMAREA=${RTC_TEAMAREA:-}
export AUTO_BUILD_TYPE=${AUTO_BUILD_TYPE:-smoke}

export CREATELINKS=${CREATELINKS:-true}

if [ ! -n "${RTC_TEAMAREA}" ]; then
  export CCAHOME=${CCAHOME:-~/cca/$AUTO_BRANCH-$AUTO_BUILD_TYPE}
else
  export CCAHOME=${CCAHOME:-~/cca/$AUTO_BRANCH-$RTC_TEAMAREA-$AUTO_BUILD_TYPE}
fi

#-------------------------------------------------------------------
. $CCAHOME/cca.core/scripts/.functions
if [ ! ${PIPESTATUS[0]} == 0 ]; then exit; fi
#-------------------------------------------------------------------

export BUILDVERSION=`buildVersion`

DISTHOME=${DISTHOME:-/dist/cca}

ROOT=$DISTHOME/nightlybuilds/$BUILDVERSION
if [ "$LOCALE" == "en" ]; then
  DVD1=$DISTHOME/nightlybuilds/$BUILDVERSION/dvd1
else
  DVD1=$DISTHOME/nightlybuilds/$BUILDVERSION/dvd1.$LOCALE
fi
DVD2=dvd2
DVD3=dvd3
DVD4=eemdvd
INTEGRATIONCD=$DISTHOME/nightlybuilds/$BUILDVERSION/integration_cd

#DOCSDVDFOLDER=$DVD1/Doc
CCADVDFOLDER=$DVD1/CCA
NDGDVDFOLDER=$DVD1/NDG
#CATALYSTDVDFOLDER=$DVD1/Catalyst

CADISTHOME=${CADISTHOME:-/dist}
CAINSTALLS=${CAINSTALLS:-D:\\Installs\\CA}

NDGFOLDER=${NDGFOLDER:-candg/nightlybuilds/r2.8.7.6}
#EEMFOLDER=${EEMFOLDER:-CA Embedded Entitlements Manager r12.51 CR02}
#BOXIFOLDER=${BOXIFOLDER:-BIEK\\GA\\3_3\\3_3_0_2\\Windows}
#BOXIPATCHESFOLDER=${BOXIPATCHESFOLDER:-BIEK\\GA\\3_3\\Patches}
#CATALYSTFOLDER=${CATALYSTFOLDER:-catalyst-installer-3.2.0.535}
#CONTAINERFOLDER=${CONTAINERFOLDER:-container-installer-3.2.0.535}
#CCACONNECTORFOLDER=${CCACONNECTORFOLDER:-cca-connector-installer-12.8.2.3}
#CATALYSTDOCFOLDER=${CATALYSTDOCFOLDER:-CA Catalyst r3.1 Docs}

function createStructure() {
  if [ ! -d "$DVD1/." ]; then
    echo \$ mkdir -p "$DVD1"
    mkdir -p "$DVD1"
  fi

  #if [ ! -d "$DOCSDVDFOLDER/." ]; then
  ##  echo \$ mkdir -p "$DOCSDVDFOLDER"
  #  mkdir -p "$DOCSDVDFOLDER"
  #fi
  if [ ! -d "$CCADVDFOLDER/." ]; then
    echo \$ mkdir -p "$CCADVDFOLDER"
    mkdir -p "$CCADVDFOLDER"
  fi
  if [ ! -d "$CCADVDFOLDER/Server/." ]; then
    echo \$ mkdir -p "$CCADVDFOLDER/Server"
    mkdir -p "$CCADVDFOLDER/Server"
  fi
  if [ ! -d "$CCADVDFOLDER/Server/Windows/." ]; then
    echo \$ mkdir -p "$CCADVDFOLDER/Server/Windows"
    mkdir -p "$CCADVDFOLDER/Server/Windows"
  fi
  if [ ! -n "${IGNOREMISSING}" -o \
       -d "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Linux/." ]; then
    if [ ! -d "$CCADVDFOLDER/Server/Linux/." ]; then
      echo \$ mkdir -p "$CCADVDFOLDER/Server/Linux"
      mkdir -p "$CCADVDFOLDER/Server/Linux"
    fi
  fi
  if [ ! -n "${IGNOREMISSING}" -o \
       -d "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Solaris/." ]; then
    if [ ! -d "$CCADVDFOLDER/Server/Solaris/." ]; then
      echo \$ mkdir -p "$CCADVDFOLDER/Server/Solaris"
      mkdir -p "$CCADVDFOLDER/Server/Solaris"
    fi
  fi

  if [ ! -d "$CCADVDFOLDER/Gridnode/." ]; then
    echo \$ mkdir -p "$CCADVDFOLDER/Gridnode"
    mkdir -p "$CCADVDFOLDER/Gridnode"
  fi
  if [ ! -d "$CCADVDFOLDER/Gridnode/Windows/." ]; then
    echo \$ mkdir -p "$CCADVDFOLDER/Gridnode/Windows"
    mkdir -p "$CCADVDFOLDER/Gridnode/Windows"
  fi
  if [ ! -n "${IGNOREMISSING}" -o \
       -d "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Linux/." ]; then
    if [ ! -d "$CCADVDFOLDER/Gridnode/Linux/." ]; then
      echo \$ mkdir -p "$CCADVDFOLDER/Gridnode/Linux"
      mkdir -p "$CCADVDFOLDER/Gridnode/Linux"
    fi
  fi
  if [ ! -n "${IGNOREMISSING}" -o \
       -d "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Solaris/." ]; then
    if [ ! -d "$CCADVDFOLDER/Gridnode/Solaris/." ]; then
      echo \$ mkdir -p "$CCADVDFOLDER/Gridnode/Solaris"
      mkdir -p "$CCADVDFOLDER/Gridnode/Solaris"
    fi
  fi

  if [ ! -d "$CCADVDFOLDER/Agents/." ]; then
    echo \$ mkdir -p "$CCADVDFOLDER/Agents"
    mkdir -p "$CCADVDFOLDER/Agents"
  fi
  if [ ! -d "$CCADVDFOLDER/Agents/Windows/." ]; then
    echo \$ mkdir -p "$CCADVDFOLDER/Agents/Windows"
    mkdir -p "$CCADVDFOLDER/Agents/Windows"
  fi
  if [ ! -d "$CCADVDFOLDER/Agents/Windows/reginfo/." ]; then
    echo \$ mkdir -p "$CCADVDFOLDER/Agents/Windows/reginfo"
    mkdir -p "$CCADVDFOLDER/Agents/Windows/reginfo"
  fi

  if [ "$CCABUILDUNIXAGENTS" == "true" ]; then
    if [ -n "${AIX2BUILDSVR}" ]; then
      if [ ! -n "${IGNOREMISSING}" -o \
           -d "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/AIX/." ]; then
        if [ ! -d "$CCADVDFOLDER/Agents/AIX/." ]; then
          echo \$ mkdir -p "$CCADVDFOLDER/Agents/AIX"
          mkdir -p "$CCADVDFOLDER/Agents/AIX"
        fi
        if [ ! -d "$CCADVDFOLDER/Agents/AIX/reginfo/." ]; then
          echo \$ mkdir -p "$CCADVDFOLDER/Agents/AIX/reginfo"
          mkdir -p "$CCADVDFOLDER/Agents/AIX/reginfo"
        fi
      fi
    fi

    if [ -n "${HPUXBUILDSVR}" ]; then
      if [ ! -n "${IGNOREMISSING}" -o \
           -d "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/HPUX/." ]; then
        if [ ! -d "$CCADVDFOLDER/Agents/HPUX/." ]; then
          echo \$ mkdir -p "$CCADVDFOLDER/Agents/HPUX"
          mkdir -p "$CCADVDFOLDER/Agents/HPUX"
        fi
        if [ ! -d "$CCADVDFOLDER/Agents/HPUX/reginfo/." ]; then
          echo \$ mkdir -p "$CCADVDFOLDER/Agents/HPUX/reginfo"
          mkdir -p "$CCADVDFOLDER/Agents/HPUX/reginfo"
        fi
      fi
    fi

    if [ ! -n "${IGNOREMISSING}" -o \
         -d "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Linux/." ]; then
      if [ ! -d "$CCADVDFOLDER/Agents/Linux/." ]; then
        echo \$ mkdir -p "$CCADVDFOLDER/Agents/Linux"
        mkdir -p "$CCADVDFOLDER/Agents/Linux"
      fi
      if [ ! -d "$CCADVDFOLDER/Agents/Linux/reginfo/." ]; then
        echo \$ mkdir -p "$CCADVDFOLDER/Agents/Linux/reginfo"
        mkdir -p "$CCADVDFOLDER/Agents/Linux/reginfo"
      fi
    fi
    if [ ! -n "${IGNOREMISSING}" -o \
         -d "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Solaris/." ]; then
      if [ ! -d "$CCADVDFOLDER/Agents/Solaris/." ]; then
        echo \$ mkdir -p "$CCADVDFOLDER/Agents/Solaris"
        mkdir -p "$CCADVDFOLDER/Agents/Solaris"
      fi
      if [ ! -d "$CCADVDFOLDER/Agents/Solaris/reginfo/." ]; then
        echo \$ mkdir -p "$CCADVDFOLDER/Agents/Solaris/reginfo"
        mkdir -p "$CCADVDFOLDER/Agents/Solaris/reginfo"
      fi
    fi
  fi

  #if [ ! -d "$CCADVDFOLDER/CMDB/." ]; then
  #  echo \$ mkdir -p "$CCADVDFOLDER/CMDB"
  #  mkdir -p "$CCADVDFOLDER/CMDB"
  #fi
  #if [ ! -d "$CCADVDFOLDER/CMDB/Windows/." ]; then
  #  echo \$ mkdir -p "$CCADVDFOLDER/CMDB/Windows"
  #  mkdir -p "$CCADVDFOLDER/CMDB/Windows"
  #fi
  #if [ -d "$CCAHOME/cca.installers/build/caacm-cmdb-patch-installer.tmp_Build_Output/Web_Installers/InstData/Linux/." -o \
  #     -d "$CCAHOME/cca.installers/build/caacm-cmdb-patch-installer.tmp_Build_Output/Web_Installers/InstData/Linux64/." ]; then
  #  if [ ! -d "$CCADVDFOLDER/CMDB/Linux/." ]; then
  #    echo \$ mkdir -p "$CCADVDFOLDER/CMDB/Linux"
  #    mkdir -p "$CCADVDFOLDER/CMDB/Linux"
  #  fi
  #fi
}

# Make sure the /dist area is mounted.
if [ ! -d "/dist/." ]; then
  echo mkdir -p "/dist/"
  mkdir -p "/dist/"
fi

# Ensure the target directory exists
if [ ! -d "$DVD1/." ]; then
  echo mkdir -p "$DVD1/"
  mkdir -p "$DVD1/"
fi

createStructure

## Server installers #########################
# Windows
if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Windows/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Windows/installserver.exe" \
     --target-directory="$CCADVDFOLDER/Server/Windows"
  cp -fv "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Windows/installserver.exe" \
     --target-directory="$CCADVDFOLDER/Server/Windows"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi

# Windows x64
if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/Server_Installers/$LOCALE/Windows/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Windows/installserver64.exe" \
   "$CCADVDFOLDER/Server/Windows/installserver64.exe"
  cp -fv "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Windows/installserver64.exe" \
     "$CCADVDFOLDER/Server/Windows/installserver64.exe"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi

# Solaris
if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Solaris/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Solaris/installserver.bin" \
     --target-directory="$CCADVDFOLDER/Server/Solaris"
  cp -fv "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Solaris/installserver.bin" \
     --target-directory="$CCADVDFOLDER/Server/Solaris"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi

# Linux
if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Linux/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Linux/installserver.bin" \
     --target-directory="$CCADVDFOLDER/Server/Linux"
  cp -fv "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Linux/installserver.bin" \
     --target-directory="$CCADVDFOLDER/Server/Linux"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi

# Linux x64
if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Linux/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Linux/installserver64.bin" \
   "$CCADVDFOLDER/Server/Linux/installserver64.bin"
  cp -fv "$CCAHOME/cca.installers/build/Server_Installers/$LOCALE/Linux/installserver64.bin" \
     "$CCADVDFOLDER/Server/Linux/installserver64.bin"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi


## grid node installers #########################
if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Windows/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Windows/installgridnode.exe" \
     --target-directory="$CCADVDFOLDER/Gridnode/Windows"
  cp -fv "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Windows/installgridnode.exe" \
     --target-directory="$CCADVDFOLDER/Gridnode/Windows"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi

if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Windows/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Windows/installgridnode64.exe" \
    "$CCADVDFOLDER/Gridnode/Windows/installgridnode64.exe"
  cp -fv "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Windows/installgridnode64.exe" \
    "$CCADVDFOLDER/Gridnode/Windows/installgridnode64.exe"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi

if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Solaris/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Solaris/installgridnode.bin" \
     --target-directory="$CCADVDFOLDER/Gridnode/Solaris"
  cp -fv "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Solaris/installgridnode.bin" \
     --target-directory="$CCADVDFOLDER/Gridnode/Solaris"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi

if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Linux/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Linux/installgridnode.bin" \
     --target-directory="$CCADVDFOLDER/Gridnode/Linux"
  cp -fv "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Linux/installgridnode.bin" \
     --target-directory="$CCADVDFOLDER/Gridnode/Linux"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi

if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Linux/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Linux/installgridnode64.bin" \
    "$CCADVDFOLDER/Gridnode/Linux/installgridnode64.bin"
  cp -fv "$CCAHOME/cca.installers/build/Grid_Installers/$LOCALE/Linux/installgridnode64.bin" \
    "$CCADVDFOLDER/Gridnode/Linux/installgridnode64.bin"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi

## agent installers #########################
echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Windows/AgentWindows.exe" "$CCADVDFOLDER/Agents/Windows/AgentWindows.exe"
cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Windows/AgentWindows.exe" "$CCADVDFOLDER/Agents/Windows/AgentWindows.exe"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Windows/AgentWindowsVM.exe" "$CCADVDFOLDER/Agents/Windows/AgentWindowsVM.exe"
cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Windows/AgentWindowsVM.exe" "$CCADVDFOLDER/Agents/Windows/AgentWindowsVM.exe"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Windows/AgentWindows64.exe" "$CCADVDFOLDER/Agents/Windows/AgentWindows64.exe"
cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Windows/AgentWindows64.exe" "$CCADVDFOLDER/Agents/Windows/AgentWindows64.exe"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Windows/AgentWindows64VM.exe" "$CCADVDFOLDER/Agents/Windows/AgentWindows64VM.exe"
cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Windows/AgentWindows64VM.exe" "$CCADVDFOLDER/Agents/Windows/AgentWindows64VM.exe"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Windows/installCmd.exe" "$CCADVDFOLDER/Agents/Windows/installCmd.exe"
cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Windows/installCmd.exe" "$CCADVDFOLDER/Agents/Windows/installCmd.exe"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

if [ "$CCABUILDUNIXAGENTS" == "true" ]; then
#  if [ -n "${AIX2BUILDSVR}" ]; then
#    if [ ! -n "${IGNOREMISSING}" -o \
#         -d "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/AIX/." ]; then
#      echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/AIX/AgentAIX.bin" "$CCADVDFOLDER/Agents/AIX/AgentAIX.bin"
#      cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/AIX/AgentAIX.bin" "$CCADVDFOLDER/Agents/AIX/AgentAIX.bin"
#      rc=$?
#      if [ ! $rc == 0 ]; then exit $rc; fi
#
#      echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/AIX/AgentAIXVM.bin" "$CCADVDFOLDER/Agents/AIX/AgentAIXVM.bin"
#      cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/AIX/AgentAIXVM.bin" "$CCADVDFOLDER/Agents/AIX/AgentAIXVM.bin"
#      rc=$?
#      if [ ! $rc == 0 ]; then exit $rc; fi
#    fi
#  fi

  if [ -n "${HPUXBUILDSVR}" ]; then
    if [ ! -n "${IGNOREMISSING}" -o \
         -d "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/HPUX/." ]; then
      echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/HPUX/AgentHPUX.bin" "$CCADVDFOLDER/Agents/HPUX/AgenttHPUX.bin"
      cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/HPUX/AgentHPUX.bin" "$CCADVDFOLDER/Agents/HPUX/AgentHPUX.bin"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi

      echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/HPUX/AgentHPUXVM.bin" "$CCADVDFOLDER/Agents/HPUX/AgentHPUXVM.bin"
      cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/HPUX/AgentHPUXVM.bin" "$CCADVDFOLDER/Agents/HPUX/AgentHPUXVM.bin"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi

      echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/HPUX/AgentHPUXPA-RISCVM.bin" "$CCADVDFOLDER/Agents/HPUX/AgentHPUXPA-RISCVM.bin"
      cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/HPUX/AgentHPUXPA-RISCVM.bin" "$CCADVDFOLDER/Agents/HPUX/AgentHPUXPA-RISCVM.bin"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi
    fi
  fi

  if [ ! -n "${IGNOREMISSING}" -o \
       -d "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Linux/." ]; then
    echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Linux/AgentLinux.bin" "$CCADVDFOLDER/Agents/Linux/AgentLinux.bin"
    cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Linux/AgentLinux.bin" "$CCADVDFOLDER/Agents/Linux/AgentLinux.bin"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi

    echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Linux/AgentLinuxVM.bin" "$CCADVDFOLDER/Agents/Linux/AgentLinuxVM.bin"
    cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Linux/AgentLinuxVM.bin" "$CCADVDFOLDER/Agents/Linux/AgentLinuxVM.bin"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  fi

  if [ ! -n "${IGNOREMISSING}" -o \
       -d "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Solaris/." ]; then
    echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Solaris/AgentSolaris.bin" "$CCADVDFOLDER/Agents/Solaris/AgentSolaris.bin"
    cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Solaris/AgentSolaris.bin" "$CCADVDFOLDER/Agents/Solaris/AgentSolaris.bin"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi

    echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Solaris/AgentSolarisVM.bin" "$CCADVDFOLDER/Agents/Solaris/AgentSolarisVM.bin"
    cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Solaris/AgentSolarisVM.bin" "$CCADVDFOLDER/Agents/Solaris/AgentSolarisVM.bin"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi

    echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Solaris/AgentSolarisIntel.bin" "$CCADVDFOLDER/Agents/Solaris/AgentSolarisIntel.bin"
    cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Solaris/AgentSolarisIntel.bin" "$CCADVDFOLDER/Agents/Solaris/AgentSolarisIntel.bin"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi

    echo \$ cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Solaris/AgentSolarisIntelVM.bin" "$CCADVDFOLDER/Agents/Solaris/AgentSolarisIntelVM.bin"
    cp -fv "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Solaris/AgentSolarisIntelVM.bin" "$CCADVDFOLDER/Agents/Solaris/AgentSolarisIntelVM.bin"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  fi
fi

## agent SDO files #########################
echo \$ cp -fv "$CCAHOME/cca.installers/SDO/SDRegister.exe" "$CCADVDFOLDER/Agents/SDRegister.exe"
cp -fv "$CCAHOME/cca.installers/SDO/SDRegister.exe" "$CCADVDFOLDER/Agents/SDRegister.exe"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

# Windows
echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Windows/agent.properties" "$CCADVDFOLDER/Agents/Windows/agent.properties"
cp -fv "$CCAHOME/cca.installers/SDO/Windows/agent.properties" "$CCADVDFOLDER/Agents/Windows/agent.properties"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Windows/AgentWindows.ini" "$CCADVDFOLDER/Agents/Windows/AgentWindows.ini"
cp -fv "$CCAHOME/cca.installers/SDO/Windows/AgentWindows.ini" "$CCADVDFOLDER/Agents/Windows/AgentWindows.ini"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Windows/reginfo/events.dat" "$CCADVDFOLDER/Agents/Windows/reginfo/events.dat"
cp -fv "$CCAHOME/cca.installers/SDO/Windows/reginfo/events.dat" "$CCADVDFOLDER/Agents/Windows/reginfo/events.dat"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Windows/reginfo/itemproc.dat" "$CCADVDFOLDER/Agents/Windows/reginfo/itemproc.dat"
cp -fv "$CCAHOME/cca.installers/SDO/Windows/reginfo/itemproc.dat" "$CCADVDFOLDER/Agents/Windows/reginfo/itemproc.dat"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Windows/reginfo/rsw.dat" "$CCADVDFOLDER/Agents/Windows/reginfo/rsw.dat"
cp -fv "$CCAHOME/cca.installers/SDO/Windows/reginfo/rsw.dat" "$CCADVDFOLDER/Agents/Windows/reginfo/rsw.dat"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

if [ "$CCABUILDUNIXAGENTS" == "true" ]; then
  if [ -n "${AIX2BUILDSVR}" ]; then
    # AIX
    if [ -d "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/AIX/." ]; then
      echo \$ cp -fv "$CCAHOME/cca.installers/SDO/AIX/agent.properties" "$CCADVDFOLDER/Agents/AIX/agent.properties"
      cp -fv "$CCAHOME/cca.installers/SDO/AIX/agent.properties" "$CCADVDFOLDER/Agents/AIX/agent.properties"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi

      echo \$ cp -fv "$CCAHOME/cca.installers/SDO/AIX/AgentAIX.ini" "$CCADVDFOLDER/Agents/AIX/AgentAIX.ini"
      cp -fv "$CCAHOME/cca.installers/SDO/AIX/AgentAIX.ini" "$CCADVDFOLDER/Agents/AIX/AgentAIX.ini"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi

      echo \$ cp -fv "$CCAHOME/cca.installers/SDO/AIX/reginfo/events.dat" "$CCADVDFOLDER/Agents/AIX/reginfo/events.dat"
      cp -fv "$CCAHOME/cca.installers/SDO/AIX/reginfo/events.dat" "$CCADVDFOLDER/Agents/AIX/reginfo/events.dat"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi

      echo \$ cp -fv "$CCAHOME/cca.installers/SDO/AIX/reginfo/itemproc.dat" "$CCADVDFOLDER/Agents/AIX/reginfo/itemproc.dat"
      cp -fv "$CCAHOME/cca.installers/SDO/AIX/reginfo/itemproc.dat" "$CCADVDFOLDER/Agents/AIX/reginfo/itemproc.dat"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi

      echo \$ cp -fv "$CCAHOME/cca.installers/SDO/AIX/reginfo/rsw.dat" "$CCADVDFOLDER/Agents/AIX/reginfo/rsw.dat"
      cp -fv "$CCAHOME/cca.installers/SDO/AIX/reginfo/rsw.dat" "$CCADVDFOLDER/Agents/AIX/reginfo/rsw.dat"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi
    fi
  fi

  if [ -n "${HPUXBUILDSVR}" ]; then
    # HPUX
    if [ -d "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/HPUX/." ]; then
      echo \$ cp -fv "$CCAHOME/cca.installers/SDO/HPUX/agent.properties" "$CCADVDFOLDER/Agents/HPUX/agent.properties"
      cp -fv "$CCAHOME/cca.installers/SDO/HPUX/agent.properties" "$CCADVDFOLDER/Agents/HPUX/agent.properties"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi
  
      echo \$ cp -fv "$CCAHOME/cca.installers/SDO/HPUX/AgentHPUX.ini" "$CCADVDFOLDER/Agents/HPUX/AgentHPUX.ini"
      cp -fv "$CCAHOME/cca.installers/SDO/HPUX/AgentHPUX.ini" "$CCADVDFOLDER/Agents/HPUX/AgentHPUX.ini"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi
  
      echo \$ cp -fv "$CCAHOME/cca.installers/SDO/HPUX/AgentHPUXPA-RISC.ini" "$CCADVDFOLDER/Agents/HPUX/AgentHPUXPA-RISC.ini"
      cp -fv "$CCAHOME/cca.installers/SDO/HPUX/AgentHPUXPA-RISC.ini" "$CCADVDFOLDER/Agents/HPUX/AgentHPUXPA-RISC.ini"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi
  
      echo \$ cp -fv "$CCAHOME/cca.installers/SDO/HPUX/reginfo/events.dat" "$CCADVDFOLDER/Agents/HPUX/reginfo/events.dat"
      cp -fv "$CCAHOME/cca.installers/SDO/HPUX/reginfo/events.dat" "$CCADVDFOLDER/Agents/HPUX/reginfo/events.dat"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi
  
      echo \$ cp -fv "$CCAHOME/cca.installers/SDO/HPUX/reginfo/itemproc.dat" "$CCADVDFOLDER/Agents/HPUX/reginfo/itemproc.dat"
      cp -fv "$CCAHOME/cca.installers/SDO/HPUX/reginfo/itemproc.dat" "$CCADVDFOLDER/Agents/HPUX/reginfo/itemproc.dat"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi
  
      echo \$ cp -fv "$CCAHOME/cca.installers/SDO/HPUX/reginfo/rsw.dat" "$CCADVDFOLDER/Agents/HPUX/reginfo/rsw.dat"
      cp -fv "$CCAHOME/cca.installers/SDO/HPUX/reginfo/rsw.dat" "$CCADVDFOLDER/Agents/HPUX/reginfo/rsw.dat"
      rc=$?
      if [ ! $rc == 0 ]; then exit $rc; fi
    fi
  fi

  # Linux
  if [ -d "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Linux/." ]; then
    echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Linux/agent.properties" "$CCADVDFOLDER/Agents/Linux/agent.properties"
    cp -fv "$CCAHOME/cca.installers/SDO/Linux/agent.properties" "$CCADVDFOLDER/Agents/Linux/agent.properties"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  
    echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Linux/AgentLinux.ini" "$CCADVDFOLDER/Agents/Linux/AgentLinux.ini"
    cp -fv "$CCAHOME/cca.installers/SDO/Linux/AgentLinux.ini" "$CCADVDFOLDER/Agents/Linux/AgentLinux.ini"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  
    echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Linux/reginfo/events.dat" "$CCADVDFOLDER/Agents/Linux/reginfo/events.dat"
    cp -fv "$CCAHOME/cca.installers/SDO/Linux/reginfo/events.dat" "$CCADVDFOLDER/Agents/Linux/reginfo/events.dat"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  
    echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Linux/reginfo/itemproc.dat" "$CCADVDFOLDER/Agents/Linux/reginfo/itemproc.dat"
    cp -fv "$CCAHOME/cca.installers/SDO/Linux/reginfo/itemproc.dat" "$CCADVDFOLDER/Agents/Linux/reginfo/itemproc.dat"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  
    echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Linux/reginfo/rsw.dat" "$CCADVDFOLDER/Agents/Linux/reginfo/rsw.dat"
    cp -fv "$CCAHOME/cca.installers/SDO/Linux/reginfo/rsw.dat" "$CCADVDFOLDER/Agents/Linux/reginfo/rsw.dat"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  fi

  # Solaris
  if [ -d "$CCAHOME/cca.installers/build/Agent_Installers/$LOCALE/Solaris/." ]; then
    echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Solaris/agent.properties" "$CCADVDFOLDER/Agents/Solaris/agent.properties"
    cp -fv "$CCAHOME/cca.installers/SDO/Solaris/agent.properties" "$CCADVDFOLDER/Agents/Solaris/agent.properties"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  
    echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Solaris/AgentSolaris.ini" "$CCADVDFOLDER/Agents/Solaris/AgentSolaris.ini"
    cp -fv "$CCAHOME/cca.installers/SDO/Solaris/AgentSolaris.ini" "$CCADVDFOLDER/Agents/Solaris/AgentSolaris.ini"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  
    echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Solaris/AgentSolarisIntel.ini" "$CCADVDFOLDER/Agents/Solaris/AgentSolarisIntel.ini"
    cp -fv "$CCAHOME/cca.installers/SDO/Solaris/AgentSolarisIntel.ini" "$CCADVDFOLDER/Agents/Solaris/AgentSolarisIntel.ini"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  
    echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Solaris/reginfo/events.dat" "$CCADVDFOLDER/Agents/Solaris/reginfo/events.dat"
    cp -fv "$CCAHOME/cca.installers/SDO/Solaris/reginfo/events.dat" "$CCADVDFOLDER/Agents/Solaris/reginfo/events.dat"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  
    echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Solaris/reginfo/itemproc.dat" "$CCADVDFOLDER/Agents/Solaris/reginfo/itemproc.dat"
    cp -fv "$CCAHOME/cca.installers/SDO/Solaris/reginfo/itemproc.dat" "$CCADVDFOLDER/Agents/Solaris/reginfo/itemproc.dat"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  
    echo \$ cp -fv "$CCAHOME/cca.installers/SDO/Solaris/reginfo/rsw.dat" "$CCADVDFOLDER/Agents/Solaris/reginfo/rsw.dat"
    cp -fv "$CCAHOME/cca.installers/SDO/Solaris/reginfo/rsw.dat" "$CCADVDFOLDER/Agents/Solaris/reginfo/rsw.dat"
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  fi
fi

## acm-cmdb installer #########################
#if [ ! -n "${IGNOREMISSING}" -o \
#     -d "$CCAHOME/cca.installers/build/caacm-cmdb-patch-installer.tmp_Build_Output/Web_Installers/InstData/Windows/." ]; then
#  echo \$ cp -fv "$CCAHOME/cca.installers/build/CMDB_Installers/$LOCALE/Windows/cca-cmdb.exe" \
#     --target-directory="$CCADVDFOLDER/CMDB/Windows"
#  cp -fv "$CCAHOME/cca.installers/build/CMDB_Installers/$LOCALE/Windows/cca-cmdb.exe" \
#     --target-directory="$CCADVDFOLDER/CMDB/Windows"
#  rc=$?
#  if [ ! $rc == 0 ]; then exit $rc; fi
#fi

## sdk ##############################
if [ ! -d "$INTEGRATIONCD/." ]; then
  echo \$ mkdir -p "$INTEGRATIONCD"
  mkdir -p "$INTEGRATIONCD"
fi

#if [ ! -d "$INTEGRATIONCD/merge modules/." ]; then
#  echo \$ mkdir -p "$INTEGRATIONCD/merge modules"
#  mkdir -p "$INTEGRATIONCD/merge modules"
#fi
#if [ ! -d "$INTEGRATIONCD/samples/installer/." ]; then
#  echo \$ mkdir -p "$INTEGRATIONCD/samples/installer"
#  mkdir -p "$INTEGRATIONCD/samples/installer"
#fi
#
#echo \$ cp -fv "$CCAHOME/cca.installers/build/Merge_Modules/cca-server-installer-ui-mm.iam.zip" "$INTEGRATIONCD/merge modules/cca-server-installer-ui-mm.iam.zip"
#cp -fv "$CCAHOME/cca.installers/build/Merge_Modules/cca-server-installer-ui-mm.iam.zip" "$INTEGRATIONCD/merge modules/cca-server-installer-ui-mm.iam.zip"
##if [ ! $? == 0 ]; then exit $?; fi
#
#echo \$ cp -fv "$CCAHOME/cca.installers/build/Merge_Modules/cca-server-installer-mm.iam.zip" "$INTEGRATIONCD/merge modules/cca-server-installer-mm.iam.zip"
#cp -fv "$CCAHOME/cca.installers/build/Merge_Modules/cca-server-installer-mm.iam.zip" "$INTEGRATIONCD/merge modules/cca-server-installer-mm.iam.zip"
#if [ ! $? == 0 ]; then exit $?; fi
#
#echo \$ cp -fv "$CCAHOME/cca.installers/cca-server-consumer-sample.iap_xml" "$INTEGRATIONCD/samples/installer/cca-server-consumer-sample.iap_xml" 
#cp -fv "$CCAHOME/cca.installers/cca-server-consumer-sample.iap_xml" "$INTEGRATIONCD/samples/installer/cca-server-consumer-sample.iap_xml" 
#if [ ! $? == 0 ]; then exit $?; fi
#
#echo \$ cp -fv "$CCAHOME/cca.installers/build/lib/RecordConsumerVariables.jar" "$INTEGRATIONCD/samples/installer/RecordConsumerVariables.jar" 
#cp -fv "$CCAHOME/cca.installers/build/lib/RecordConsumerVariables.jar" "$INTEGRATIONCD/samples/installer/RecordConsumerVariables.jar" 
#if [ ! $? == 0 ]; then exit $?; fi

if [ ! -d "$INTEGRATIONCD/sdk/doc/." ]; then
  echo \$ mkdir -p "$INTEGRATIONCD/sdk/doc"
  mkdir -p "$INTEGRATIONCD/sdk/doc"
fi
#if [ ! -d "$INTEGRATIONCD/sdk/lib/." ]; then
#  echo \$ mkdir -p "$INTEGRATIONCD/sdk/lib"
#  mkdir -p "$INTEGRATIONCD/sdk/lib"
#fi

echo \$ cp -fvR "$CCAHOME/cca.core/caacm-sdk/build/sdk/doc" "$INTEGRATIONCD/sdk" 
cp -fvR "$CCAHOME/cca.core/caacm-sdk/build/sdk/doc" "$INTEGRATIONCD/sdk" 
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

#echo \$ cp -fv "$CCAHOME/cca.core/caacm-sdk/build/sdk/lib/caacm-api.jar" "$INTEGRATIONCD/sdk/lib/caacm-api.jar" 
#cp -fv "$CCAHOME/cca.core/caacm-sdk/build/sdk/lib/caacm-api.jar" "$INTEGRATIONCD/sdk/lib/caacm-api.jar" 
#rc=$?
#if [ ! $rc == 0 ]; then exit $rc; fi
#
#echo \$ cp -fv "$CCAHOME/cca.core/caacm-sdk/build/lib/caacm-aux.jar" "$INTEGRATIONCD/sdk/lib/caacm-aux.jar" 
#cp -fv "$CCAHOME/cca.core/caacm-sdk/build/lib/caacm-aux.jar" "$INTEGRATIONCD/sdk/lib/caacm-aux.jar" 
#rc=$?
#if [ ! $rc == 0 ]; then exit $rc; fi


## NDG ##############################
if [ -n "${CREATELINKS}" ]; then
  echo Network Discovery Gateway installer directory: "$CADISTHOME/$NDGFOLDER"
  if [ -d "$CADISTHOME/$NDGFOLDER/." ]; then
    if [ ! -d "$NDGDVDFOLDER/." ]; then
      echo \$ mkdir -p "$NDGDVDFOLDER"
      mkdir -p "$NDGDVDFOLDER"
    fi

    echo \$ cp -fv "$CADISTHOME/$NDGFOLDER/installers/$LOCALE/installndg.exe" "$NDGDVDFOLDER" 
    cp -fv "$CADISTHOME/$NDGFOLDER/installers/$LOCALE/installndg.exe" "$NDGDVDFOLDER" 
    rc=$?
    if [ ! $rc == 0 ]; then exit $rc; fi
  else
    if [ ! -n "${IGNOREMISSING}" ]; then
      echo Error: Network Discovery Gateway installer 'installndg.exe' not found.
      exit -1
    fi
  fi
fi

## EEM #############################
#if [ -n "${CREATELINKS}" ]; then
#  echo \$ cd $ROOT
#  cd $ROOT
#  echo \$ linkd.exe $DVD4 \"$CAINSTALLS\\$EEMFOLDER\"
#  linkd.exe $DVD4 "$CAINSTALLS\\$EEMFOLDER"
#  rc=$?
#  if [ ! $rc == 0 ]; then exit $rc; fi
#fi

## BOXI #############################
#if [ -n "${CREATELINKS}" ]; then
#  echo \$ cd $ROOT
#  cd $ROOT
#  echo \$ linkd.exe $DVD2 \"$CAINSTALLS\\$BOXIFOLDER\"
#  linkd.exe $DVD2 "$CAINSTALLS\\$BOXIFOLDER"
#  rc=$?
#  if [ ! $rc == 0 ]; then exit $rc; fi
#fi

## BOXI PATCHES#############################
#if [ -n "${CREATELINKS}" ]; then
#  echo \$ cd $ROOT
#  cd $ROOT
#  echo \$ linkd.exe $DVD3 \"$CAINSTALLS\\$BOXIPATCHESFOLDER\"
#  linkd.exe $DVD3 "$CAINSTALLS\\$BOXIPATCHESFOLDER"
#  rc=$?
#  if [ ! $rc == 0 ]; then exit $rc; fi
#fi

## Catalyst #############################
#if [ -n "${CREATELINKS}" ]; then
#  echo \$ cd $DVD1
#  cd $DVD1

  #if [ ! -d "$CATALYSTDVDFOLDER/." ]; then
  #  echo \$ mkdir -p "$CATALYSTDVDFOLDER"
  #  mkdir -p "$CATALYSTDVDFOLDER"
  #fi

  #echo \$ linkd.exe \"Catalyst\\Server\" \"$CAINSTALLS\\$CATALYSTFOLDER\"
  #linkd.exe "Catalyst\\Server" "$CAINSTALLS\\$CATALYSTFOLDER"
  #rc=$?
  #if [ ! $rc == 0 ]; then exit $rc; fi

  #echo \$ linkd.exe \"Catalyst\\Container\" \"$CAINSTALLS\\$CONTAINERFOLDER\"
  #linkd.exe "Catalyst\\Container" "$CAINSTALLS\\$CONTAINERFOLDER"
  #rc=$?
  #if [ ! $rc == 0 ]; then exit $rc; fi

  #echo \$ linkd.exe \"Catalyst\\CCA Connector\" \"$CAINSTALLS\\$CCACONNECTORFOLDER\"
  #linkd.exe "Catalyst\\CCA Connector" "$CAINSTALLS\\$CCACONNECTORFOLDER"
  #rc=$?
  #if [ ! $rc == 0 ]; then exit $rc; fi
#fi


## dvdsetup ##############################
echo \$ cp -fv "$CCAHOME/cca.installers/build/license_$LOCALE.txt" "$DVD1/license.txt" 
cp -fv "$CCAHOME/cca.installers/build/license_$LOCALE.txt" "$DVD1/license.txt" 
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

echo \$ cp -fv "$CCAHOME/cca.documentation/CCA_License_$LOCALE.html" "$DVD1/license.html"
cp -fv "$CCAHOME/cca.documentation/CCA_License_$LOCALE.html" "$DVD1/license.html"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

echo \$ cp -fv "$CCAHOME/cca.documentation/CCA_Readme_$LOCALE.html" "$DVD1/readme.html" 
cp -fv "$CCAHOME/cca.documentation/CCA_Readme_$LOCALE.html" "$DVD1/readme.html"
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

#if [ "$LOCALE" == "ja" ]; then
#  echo \$ cp -fv "$CCAHOME/cca.documentation/CCA_RelNotes_JPN.pdf" "$DVD1" 
#  cp -fv "$CCAHOME/cca.documentation/CCA_RelNotes_JPN.pdf" "$DVD1" 
#  rc=$?
#  if [ ! $rc == 0 ]; then exit $rc; fi
#else
#  echo \$ cp -fv "$CCAHOME/cca.documentation/CCA_RelNotes_ENU.pdf" "$DVD1" 
#  cp -fv "$CCAHOME/cca.documentation/CCA_RelNotes_ENU.pdf" "$DVD1" 
#  rc=$?
#  if [ ! $rc == 0 ]; then exit $rc; fi
#fi

#echo \$ unzip -uo "$CCAHOME/cca.documentation/CCA_Bookshelf_$LOCALE.zip" -d "$DOCSDVDFOLDER" 
#unzip -uo "$CCAHOME/cca.documentation/CCA_Bookshelf_$LOCALE.zip" -d "$DOCSDVDFOLDER" 
#rc=$?
#if [ ! $rc == 0 ]; then exit $rc; fi

echo \$ cp -fv "$CCAHOME/cca.installers/resources/dvdsetup/autorun.inf" "$DVD1" 
cp -fv "$CCAHOME/cca.installers/resources/dvdsetup/autorun.inf" "$DVD1" 
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

echo \$ cp -fv "$CCAHOME/cca.installers/resources/dvdsetup/autorun.ico" "$DVD1" 
cp -fv "$CCAHOME/cca.installers/resources/dvdsetup/autorun.ico" "$DVD1" 
rc=$?
if [ ! $rc == 0 ]; then exit $rc; fi

if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/build/Install_Browsers/$LOCALE/Windows/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Install_Browsers/$LOCALE/Windows/setup.exe" "$DVD1"
  cp -fv "$CCAHOME/cca.installers/build/Install_Browsers/$LOCALE/Windows/setup.exe" "$DVD1"
  cp -fv "$CCAHOME/cca.installers/build/Install_Browsers/$LOCALE/Windows/installer.properties" "$DVD1"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi

if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/build/Install_Browsers/$LOCALE/Solaris/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Install_Browsers/$LOCALE/Solaris/setup.bin" "$DVD1/setupsolaris.bin"
  cp -fv "$CCAHOME/cca.installers/build/Install_Browsers/$LOCALE/Solaris/setup.bin" "$DVD1/setupsolaris.bin"
  cp -fv "$CCAHOME/cca.installers/build/Install_Browsers/$LOCALE/Solaris/installer.properties" "$DVD1"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi

if [ ! -n "${IGNOREMISSING}" -o \
     -d "$CCAHOME/cca.installers/build/Install_Browsers/$LOCALE/Linux/." ]; then
  echo \$ cp -fv "$CCAHOME/cca.installers/build/Install_Browsers/$LOCALE/Linux/setup.bin" "$DVD1/setuplinux.bin"
  cp -fv "$CCAHOME/cca.installers/build/Install_Browsers/$LOCALE/Linux/setup.bin" "$DVD1/setuplinux.bin"
  cp -fv "$CCAHOME/cca.installers/build/Install_Browsers/$LOCALE/Linux/installer.properties" "$DVD1"
  rc=$?
  if [ ! $rc == 0 ]; then exit $rc; fi
fi

#if [ -d "$CCAHOME/cca.installers/build/caacm-installbrowser.tmp_Build_Output/Web_Installers/InstData/AIX/." ]; then
#  echo \$ cp -fv "$CCAHOME/cca.installers/build/caacm-installbrowser.tmp_Build_Output/Web_Installers/InstData/AIX/VM/setup.bin" "$DVD1/setupaix.bin"
#  cp -fv "$CCAHOME/cca.installers/build/caacm-installbrowser.tmp_Build_Output/Web_Installers/InstData/AIX/VM/setup.bin" "$DVD1/setupaix.bin"
#  if [ ! $? == 0 ]; then exit $?; fi
#fi
#
#if [ -d "$CCAHOME/cca.installers/build/caacm-installbrowser.tmp_Build_Output/Web_Installers/InstData/HPUX/." ]; then
#  echo \$ cp -fv "$CCAHOME/cca.installers/build/caacm-installbrowser.tmp_Build_Output/Web_Installers/InstData/HPUX/VM/setup.bin" "$DVD1/setuphpux.bin"
#  cp -fv "$CCAHOME/cca.installers/build/caacm-installbrowser.tmp_Build_Output/Web_Installers/InstData/HPUX/VM/setup.bin" "$DVD1/setuphpux.bin"
#  if [ ! $? == 0 ]; then exit $?; fi
#fi


# Ensure the sources directory exists
#if [ ! -d "$DVD1/sources/." ]; then
#  mkdir -p "$DVD1/sources/"
#fi

# create the server src tar.gz file.
#cd $CCAHOME/caacm-api/src
#find . \( -name ".svn" -or \
#          -name "*.jar" \) | sed 's/\.\///g' > ~/exclude.lst
#echo \$ tar -zcvf "$DVD1/sources/caacm.src.$BUILDVERSION.tar.gz" -X ~/exclude.lst *
#tar -zcvf "$DVD1/sources/caacm.src.$BUILDVERSION.tar.gz" -X ~/exclude.lst *
#
#rm -f ~/exclude.lst > /dev/null

)
