{ stdenv, gnome3, libmspack, wrapGAppsHook, fetchurl }:

# Getting evolution to find external plugins requires patching. Brute force
# solution: make a derivation with Evolution + EDS + plugins all in one store
# path.

with stdenv.lib;
let
    ewsSrc=fetchurl {
     url = "mirror://gnome/sources/evolution-ews/3.22/evolution-ews-3.22.0.tar.xz";
     sha256 = "1x933zsfj9mjsrj6lgjk9khzsy4q7d0cbb7whx4gdrycrsqy2b8w";
   };
   evolution_data_server = gnome3.evolution_data_server;
   evolution = gnome3.evolution;
in
stdenv.mkDerivation rec {
  name = "evolution-ews-${gnome3.version}";

  srcs = [ evolution_data_server.src evolution.src ewsSrc ];

  # - Why are the buildInputs from $pkg not available as 'buildInputs', but
  #   instead as 'nativeBuildInputs'?
  # - Filter out some paths that we must not be available in this build (or
  #   else this build will depend on those paths instead of this new "union"
  #   path).
  buildInputs = filter (x: x != evolution && x != evolution_data_server)
    (evolution_data_server.buildInputs
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
    export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$out/lib/pkgconfig"
    echo
    echo "### Building evolution-data-server"
    echo
    pushd ${evolution_data_server.name}
    ./configure --prefix=$out ${concatStringsSep " " evolution_data_server.configureFlags or []}
    make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES
    make install
    popd
    echo
    echo "### Building evolution"
    echo
    pushd ${evolution.name}
    # Save NIX_CFLAGS_COMPILE
    export ORIG_NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE"
    export NIX_CFLAGS_COMPILE="$ORIG_NIX_CFLAGS_COMPILE ${evolution.NIX_CFLAGS_COMPILE}"
    ./configure --prefix=$out ${concatStringsSep " " evolution.configureFlags or []}
    make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES
    make install
    popd
    # Restore NIX_CFLAGS_COMPILE
    export NIX_CFLAGS_COMPILE="$ORIG_NIX_CFLAGS_COMPILE"
    echo
    echo "### Building evolution-ews"
    echo
    pushd ${name}.0
    sed -e "s|\<ewsdatadir=.*|ewsdatadir=$out/share/evolution-data-server/ews|" \
            -e "s|\<privincludedir=.*|privincludedir=$out/include/evolution-data-server|" \
            -e "s|\<privlibdir=.*|privlibdir=$out/lib/evolution-data-server|" \
            -e "s|\<camel_providerdir=.*|camel_providerdir=$out/lib/evolution-data-server/camel-providers|" \
            -e "s|\<ebook_backenddir=.*|ebook_backenddir=$out/lib/evolution-data-server/addressbook-backends|" \
            -e "s|\<ecal_backenddir=.*|ecal_backenddir=$out/lib/evolution-data-server/calendar-backends|" \
            -e "s|\<edataserver_privincludedir=.*|edataserver_privincludedir=$out/include/evolution-data-server|" \
            -e "s|\<eds_moduledir=.*|eds_moduledir=$out/lib/evolution-data-server/registry-modules|" \
            -e "s|\<errordir=.*|errordir=$out/share/evolution/errors|" \
            -e "s|\<evo_moduledir=.*|evo_moduledir=$out/lib/evolution/modules|" \
            -i configure
    ./configure --prefix=$out
    make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES
    make install
    popd
    fixupPhase
  '';

  meta = with stdenv.lib; {
    description = "Personal information management application that provides integrated mail, calendaring and address book functionality (bundled with plugins)";
    homepage = https://wiki.gnome.org/Apps/Evolution;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}