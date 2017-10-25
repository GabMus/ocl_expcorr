#pragma once

std::string get_dir(const std::string filepath) {
    std::string toret = "";
    for (int i=filepath.length(); i>=0; i--) {
        if (filepath[i] == '/') {
            toret = filepath.substr(0,i);
            break;
        }
    }
    if (toret == "") {
        std::cerr << TERM_RED << "Error: provided filepath is not a valid path." << TERM_RESET;
        return NULL;
    }
    return toret;
}

void write_ppm(unsigned char* bytes, int size, int width, int height, std::string path, int colors=255) {
    std::string s = "P6\n" + std::to_string(width) + " " + std::to_string(height) + "\n" + std::to_string(colors) + "\n";
    std::string bs(reinterpret_cast<char*>(bytes), size);

    s.append(bs);
    FILE* file = fopen(path.c_str(), "wb");
    fwrite( s.c_str(), 1, s.size(), file );
    fclose(file);
}
