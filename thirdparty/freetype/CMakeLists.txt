project(freetype LANGUAGES C)

add_library(freetype STATIC)
add_library(FreeType::FreeType ALIAS freetype)
target_include_directories(freetype PUBLIC ${PROJECT_SOURCE_DIR}/include)
target_sources(freetype
  PRIVATE
    ${PROJECT_SOURCE_DIR}/src/base/ftapi.c
    ${PROJECT_SOURCE_DIR}/src/base/ftbase.c
    ${PROJECT_SOURCE_DIR}/src/base/ftbbox.c
    ${PROJECT_SOURCE_DIR}/src/base/ftbdf.c
    ${PROJECT_SOURCE_DIR}/src/base/ftbitmap.c
    ${PROJECT_SOURCE_DIR}/src/base/ftcid.c
    ${PROJECT_SOURCE_DIR}/src/base/ftdebug.c
    ${PROJECT_SOURCE_DIR}/src/base/ftfntfmt.c
    ${PROJECT_SOURCE_DIR}/src/base/ftfstype.c
    ${PROJECT_SOURCE_DIR}/src/base/ftgasp.c
    ${PROJECT_SOURCE_DIR}/src/base/ftglyph.c
    ${PROJECT_SOURCE_DIR}/src/base/ftgxval.c
    ${PROJECT_SOURCE_DIR}/src/base/ftinit.c
    ${PROJECT_SOURCE_DIR}/src/base/ftlcdfil.c
    ${PROJECT_SOURCE_DIR}/src/base/ftmm.c
    ${PROJECT_SOURCE_DIR}/src/base/ftotval.c
    ${PROJECT_SOURCE_DIR}/src/base/ftpatent.c
    ${PROJECT_SOURCE_DIR}/src/base/ftpfr.c
    ${PROJECT_SOURCE_DIR}/src/base/ftpic.c
    ${PROJECT_SOURCE_DIR}/src/base/ftstroke.c
    ${PROJECT_SOURCE_DIR}/src/base/ftsynth.c
    ${PROJECT_SOURCE_DIR}/src/base/ftsystem.c
    ${PROJECT_SOURCE_DIR}/src/base/fttype1.c
    ${PROJECT_SOURCE_DIR}/src/base/ftwinfnt.c
    ${PROJECT_SOURCE_DIR}/src/bdf/bdf.c
    ${PROJECT_SOURCE_DIR}/src/bzip2/ftbzip2.c
    ${PROJECT_SOURCE_DIR}/src/cache/ftcache.c
    ${PROJECT_SOURCE_DIR}/src/cff/cff.c
    ${PROJECT_SOURCE_DIR}/src/cid/type1cid.c
    ${PROJECT_SOURCE_DIR}/src/gxvalid/gxvalid.c
    ${PROJECT_SOURCE_DIR}/src/gzip/ftgzip.c
    ${PROJECT_SOURCE_DIR}/src/lzw/ftlzw.c
    ${PROJECT_SOURCE_DIR}/src/otvalid/otvalid.c
    ${PROJECT_SOURCE_DIR}/src/pcf/pcf.c
    ${PROJECT_SOURCE_DIR}/src/pfr/pfr.c
    ${PROJECT_SOURCE_DIR}/src/psaux/psaux.c
    ${PROJECT_SOURCE_DIR}/src/pshinter/pshinter.c
    ${PROJECT_SOURCE_DIR}/src/psnames/psnames.c
    ${PROJECT_SOURCE_DIR}/src/raster/raster.c
    ${PROJECT_SOURCE_DIR}/src/sfnt/sfnt.c
    ${PROJECT_SOURCE_DIR}/src/smooth/smooth.c
    ${PROJECT_SOURCE_DIR}/src/truetype/truetype.c
    ${PROJECT_SOURCE_DIR}/src/type1/type1.c
    ${PROJECT_SOURCE_DIR}/src/type42/type42.c
    ${PROJECT_SOURCE_DIR}/src/winfonts/winfnt.c)
