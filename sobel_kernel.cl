constant sampler_t sobel_sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST;

constant float ck_sobelx[9] = {
    1.0f, 0.0f, -1.0f,
    2.0f, 0.0f, -2.0f,
    1.0f, 0.0f, -1.0f
};

constant float ck_sobely[9] = {
    1.0f, 2.0f, 1.0f,
    0.0f, 0.0f, 0.0f,
    -1.0f, -2.0f, -1.0f
};

#define R_LUMA_C 0.2126
#define G_LUMA_C 0.7152
#define B_LUMA_C 0.0722

void kernel sobelx(read_only image2d_t in_pic, write_only image2d_t out_pic) {
    float n_pixel = 0.0f;

    #pragma unroll
    for (int i=0; i<3; i++) {
        #pragma unroll
        for (int j=0; j<3; j++) {
            float4 pixel = read_imagef(in_pic, sobel_sampler, (int2){get_global_id(0)+i-1, get_global_id(1)+j-1});
            float luma = (R_LUMA_C * pixel.z) + (G_LUMA_C * pixel.y) + (B_LUMA_C * pixel.x);
            n_pixel += luma * ck_sobelx[i+(j*3)];
        }
    }

    //n_pixel = n_pixel < .05f ? 0.0f : n_pixel;

    write_imagef(out_pic, (int2){get_global_id(0), get_global_id(1)}, n_pixel);
}

void kernel sobely(read_only image2d_t in_pic, write_only image2d_t out_pic) {
    float n_pixel = 0.0f;

    #pragma unroll
    for (int i=0; i<3; i++) {
        #pragma unroll
        for (int j=0; j<3; j++) {
            float4 pixel = read_imagef(in_pic, sobel_sampler, (int2){get_global_id(0)+i-1, get_global_id(1)+j-1});
            float luma = (R_LUMA_C * pixel.z) + (G_LUMA_C * pixel.y) + (B_LUMA_C * pixel.x);
            n_pixel += luma * ck_sobely[i+(j*3)];
        }
    }

    //n_pixel = n_pixel < .05f ? 0.0f : n_pixel;

    write_imagef(out_pic, (int2){get_global_id(0), get_global_id(1)}, n_pixel);
}

void kernel sum_sobel(read_only image2d_t i_sobelx, read_only image2d_t i_sobely, write_only image2d_t out_pic) {
    float px = read_imagef(i_sobelx, sobel_sampler, (int2){get_global_id(0), get_global_id(1)}).x;
    float py = read_imagef(i_sobely, sobel_sampler, (int2){get_global_id(0), get_global_id(1)}).x;
    float n_pixel = px > py ? px : py;

    write_imagef(out_pic, (int2){get_global_id(0), get_global_id(1)}, n_pixel);
}
