cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME readpst)
project(${PROJECT_NAME} VERSION 0.6.76 LANGUAGES CXX C)

file(GLOB_RECURSE gsfsources
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-utils.c   
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-priv.c    
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-libxml.c    
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-doc-meta-data.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-docprop-vector.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-msole-utils.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-open-pkg-utils.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-opendoc-utils.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-timestamp.c   
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-zip-utils.c   
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-input.c   
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-input-bzip.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-input-gzip.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-input-http.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-input-iochannel.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-input-memory.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-input-proxy.c   
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-input-stdio.c   
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-input-textline.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-infile.c    
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-infile-msole.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-infile-msvba.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-infile-stdio.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-infile-tar.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-infile-zip.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-output.c    
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-output-bzip.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-output-csv.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-output-gzip.c   
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-output-iconv.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-output-iochannel.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-output-memory.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-output-stdio.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-outfile.c     
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-outfile-msole.c   
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-outfile-stdio.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-outfile-zip.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-shared-memory.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-structured-blob.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-blob.c    
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-clip-data.c   
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-input-gio.c   
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/gsf-output-gio.c  
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/version.c
)
file(GLOB_RECURSE gsfheaders
  ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf/*.h
)

add_library(gsf STATIC ${gsfsources} ${gsfheaders})
target_include_directories(gsf PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/libgsf)
target_include_directories(gsf PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/libgsf/gsf)
set_target_properties(gsf PROPERTIES COMPILE_DEFINITIONS GSFLOCALEDIR=\"${CMAKE_CURRENT_SOURCE_DIR}/libgsf/share/locale\") 
target_link_libraries(gsf glib)

file(GLOB_RECURSE sources
  ${CMAKE_CURRENT_SOURCE_DIR}/libpst/src/libpst.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libpst/src/debug.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libpst/src/strfunc.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libpst/src/zfu.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libpst/src/timeconv.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libpst/src/vbuf.c 
)
file(GLOB_RECURSE headers
  ${CMAKE_CURRENT_SOURCE_DIR}/libpst-0.6.76/src/*.h 
)

add_library(pst STATIC ${sources} ${headers})
set_target_properties(pst PROPERTIES COMPILE_DEFINITIONS "HAVE_CONFIG_H")
target_include_directories(pst PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/libpst/src)
target_include_directories(pst PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/libpst/)
target_include_directories(pst PUBLIC ${CONAN_INCLUDE_DIES})

file(GLOB_RECURSE readpstsources
  ${CMAKE_CURRENT_SOURCE_DIR}/libpst/src/readpst.c 
  ${CMAKE_CURRENT_SOURCE_DIR}/libpst/src/msg.cpp 
  ${CMAKE_CURRENT_SOURCE_DIR}/libpst/src/libstrfunc.c
  ${CMAKE_CURRENT_SOURCE_DIR}/libpst/src/lzfu.c
)

add_executable(readpst ${readpstsources} ${headers})
target_link_libraries(readpst pst)
target_include_directories(readpst PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/libgsf)
set_target_properties(readpst PROPERTIES COMPILE_DEFINITIONS "VERSION=0.6.76")
set_target_properties(readpst PROPERTIES COMPILE_DEFINITIONS "HAVE_CONFIG_H")
target_link_libraries(readpst ${CMAKE_BINARY_DIR}/lib/libgsf.a)
target_link_libraries(readpst ${CMAKE_BINARY_DIR}/lib/libpst.a)
target_link_libraries(readpst ${CONAN_LIBS})

