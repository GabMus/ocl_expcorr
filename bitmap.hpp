#pragma once
#pragma pack(2)

typedef unsigned int LONG;
typedef unsigned short WORD;
typedef unsigned int DWORD;
typedef unsigned char COLORWORD; // 1 byte
typedef short int COLORPADDING; // 2 byte
typedef std::vector<char> BMPVEC;

typedef struct tagBITMAPFILEHEADER {
    WORD  bfType;
    DWORD bfSize;
    WORD  bfReserved1;
    WORD  bfReserved2;
    DWORD bfOffBits;
} BITMAPFILEHEADER, *PBITMAPFILEHEADER;

typedef struct tagBITMAPINFOHEADER {
    DWORD biSize;
    LONG  biWidth;
    LONG  biHeight;
    WORD  biPlanes;
    WORD  biBitCount;
    DWORD biCompression;
    DWORD biSizeImage;
    LONG  biXPelsPerMeter;
    LONG  biYPelsPerMeter;
    DWORD biClrUsed;
    DWORD biClrImportant;
} BITMAPINFOHEADER, *PBITMAPINFOHEADER;

typedef struct tagBMPSIZE {
    int w;
    int h;
} *PBMPSIZE, BMPSIZE;

void read_bitmap(std::string path, BMPVEC& buffer) {
    std::ifstream file(path, std::ios::binary);

    if (!file) {
        std::cerr << TERM_RED << "Error: Could not find image for path " << path << std::endl << TERM_RESET;
        exit(1);
    }

    PBITMAPFILEHEADER b_fh;
    PBITMAPINFOHEADER b_ih;

    file.seekg(0,std::ios::end);
    std::streampos length = file.tellg();
    file.seekg(0,std::ios::beg);

    buffer.resize(length);
    file.read(&buffer[0], length);

    b_fh = (PBITMAPFILEHEADER)(&buffer[0]);
    b_ih = (PBITMAPINFOHEADER)(&buffer[0] + sizeof(BITMAPFILEHEADER));

    file.close();
}

void get_bitmap_data(BMPVEC& buffer, BMPVEC& nbuffer) {
    PBITMAPFILEHEADER b_fh = (PBITMAPFILEHEADER)(&buffer[0]);
    DWORD offset = b_fh->bfOffBits;

    BMPVEC::const_iterator first = buffer.begin() + offset;
    BMPVEC::const_iterator last = buffer.end();

    nbuffer = BMPVEC(first, last);
}

DWORD get_bitmap_offset(BMPVEC& buffer) {
    PBITMAPFILEHEADER b_fh = (PBITMAPFILEHEADER)(&buffer[0]);
    return b_fh->bfOffBits;
}

void bgr2bgra(BMPVEC& rawbmp, BMPVEC& bgravec) {
    bgravec.reserve(rawbmp.size() + rawbmp.size()/3);
    int k = 0;
    for (uint i = 0; i < rawbmp.size(); i+=3) {
        bgravec[k] = rawbmp[i];
        bgravec[k+1] = rawbmp[i+1];
        bgravec[k+2] = rawbmp[i+2];
        bgravec[k+3] = 0xFF;
        k+=4;
    }
}

void bgra2rgb(float* invec, int size, unsigned char* outvec) {
    size *= 3;
    unsigned char* p = reinterpret_cast<unsigned char*>(invec);
    int k=0;
    for (int i=0; i<size; i+=3) {
        outvec[size-1-i] = p[k];
        outvec[size-1-(i+1)] = p[k+1];
        outvec[size-1-(i+2)] = p[k+2];
        k+=4;
    }
}

void y_mirror_image(unsigned char* invec, int width, int height, unsigned char* outvec) {
    //int size = width*height*3;
    int i=0, j=0;
    while (j<height) {
        if (i>=width) {i=0; j+=3;}
        outvec[i+(j*height)] = invec[width-1-i*j*height];
        i+=3;
    }
}

void bmp_single_channel2ppm_ordering(unsigned char* invec, int size, unsigned char* outvec) {
    int k=0;
    for (int i=0; i<size; i++) {
        outvec[(size*3)-1-k] = invec[i];
        outvec[(size*3)-1-(k+1)] = invec[i];
        outvec[(size*3)-1-(k+2)] = invec[i];
        k+=3;
    }
}
