{ stdenv, gnome3, libmspack, wrapGAppsHook, fetchurl, cmake, ... }:

# Getting evolution to find external plugins requires patching. Brute force
# solution: make a derivation with Evolution + EDS + plugins all in one store
# path.

with stdenv.lib;
let
    gnomeVersionBranch = gnome3.versionBranch gnome3.evolution_data_server.version;
    version = "${gnomeVersionBranch}.0";
    ewsSrc = fetchurl {
     url = "mirror://gnome/sources/evolution-ews/${gnomeVersionBranch}/evolution-ews-${version}.tar.xz";
     sha256 = "0fnlmaakrivdrsk2ajvqhmsxskzmwf09xdp8klai57z7nv5y7r6w";
   };
   evolution_data_server = gnome3.evolution_data_server;
   evolution = gnome3.evolution;
in
stdenv.mkDerivation rec {
  name = "evolution-ews-${version}";

  srcs = [ evolution_data_server.src evolution.src ewsSrc ];

  # - Why are the buildInputs from $pkg not available as 'buildInputs', but
  #   instead as 'nativeBuildInputs'?
  # - Filter out some paths that we must not be available in this build (or
  #   else this build will depend on those paths instead of this new "union"
  #   path).
  buildInputs = filter (x: x != evolution && x != evolution_data_server)
    (evolution_data_server.buildInputs
      ++ [ cmake ]
      ++ evolution.buildInputs
      ++ evolution_data_server.nativeBuildInputs
      ++ evolution.nativeBuildInputs
      ++ [ wrapGAppsHook libmspack ]
    );

  propagatedBuildInputs = filter (x: x != evolution && x != evolution_data_server)
    (evolution_data_server.propagatedBuildInputs
      ++ evolution.propagatedBuildInputs
      ++ evolution_data_server.propagatedNativeBuildInputs
      ++ evolution.propagatedNativeBuildInputs
    );

  buildCommand = ''
    for src in $srcs; do
        tar xf "$src"
    done
    export PKG_CONFIG_PATH="$out/lib/pkgconfig:$PKG_CONFIG_PATH"
    echo
    echo "### Building evolution-data-server"
    echo
    pushd ${evolution_data_server.name}
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=$out -DENABLE_UOA=OFF -DCMAKE_SKIP_BUILD_RPATH=OFF
    make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES
    make install
    popd
    echo
    echo "### Building evolution"
    echo
    pushd ${evolution.name}
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=$out ${concatStringsSep " " evolution.cmakeFlags or []}
    make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES
    make install
    popd
    echo
    echo "### Building evolution-ews"
    echo
    pushd ${name}
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=$out
    make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES
    make install
    popd
    fixupPhase
    echo "### Done"
  '';

  meta = with stdenv.lib; {
    description = "Personal information management application that provides integrated mail, calendaring and address book functionality (bundled with plugins)";
    homepage = https://wiki.gnome.org/Apps/Evolution;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
