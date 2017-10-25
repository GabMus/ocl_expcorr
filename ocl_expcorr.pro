TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += \
    main.cpp
QMAKE_CXXFLAGS += -std=c++0x
LIBS += -lOpenCL

DISTFILES += \
    zone_kernel.cl \
    edge_detection_kernel.cl \
    gaussian_kernel.cl \
    sobel_kernel.cl \
    LICENSE

copyfiles.commands = cp $$PWD/*.cl $$OUT_PWD/

QMAKE_EXTRA_TARGETS += copyfiles
POST_TARGETDEPS += copyfiles

HEADERS += \
    bitmap.hpp \
    cl_errorcheck.hpp \
    cl_errorcheck.hpp \
    bitmap.hpp \
    io_helper.hpp \
    ocl_helper.hpp
