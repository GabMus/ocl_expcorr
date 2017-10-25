constant sampler_t gauss_sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST;

constant float ck_gauss_3x[9] = {
    1.0f/16.0f, 1.0f/8.0f, 1.0f/16.0f,
    1.0f/8.0f, 1.0f/4.0f, 1.0f/8.0f,
    1.0f/16.0f, 1.0f/8.0f, 1.0f/16.0f
};

constant float ck_gauss_5x[25] = {
    1.0f/273.0f, 4.0f/273.0f, 1.0f/39.0f, 4.0f/273.0f, 1.0f/273.0f,
    4.0f/273.0f, 16.0f/273.0f, 26.0f/273.0f, 16.0f/273.0f, 4.0f/273.0f,
    1.0f/39.0f, 26.0f/273.0f, 41.0f/273.0f, 26.0f/273.0f, 1.0f/39.0f,
    4.0f/273.0f, 16.0f/273.0f, 26.0f/273.0f, 16.0f/273.0f, 4.0f/273.0f,
    1.0f/273.0f, 4.0f/273.0f, 1.0f/39.0f, 4.0f/273.0f, 1.0f/273.0f
};

void kernel gaussian(read_only image2d_t in_pic, write_only image2d_t out_pic) { // a same image cannot be rw
    float4 n_pixel = (float4){0.0f, 0.0f, 0.0f, 0.0f};

    #pragma unroll
    for (int i=0; i<5; i++) {
        #pragma unroll
        for (int j=0; j<5; j++) {
            n_pixel += read_imagef(in_pic, gauss_sampler, (int2){get_global_id(0)+i-1, get_global_id(1)+j-1}) * ck_gauss_5x[i+(j*5)];
        }
    }

    write_imagef(out_pic, (int2){get_global_id(0), get_global_id(1)},  n_pixel);
}
