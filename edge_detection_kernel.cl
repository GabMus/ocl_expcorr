constant sampler_t ed_sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST;

constant float ck_ed[9] = {
    -1.0f, -1.0f, -1.0f,
    -1.0f,  8.0f, -1.0f,
    -1.0f, -1.0f, -1.0f
};

void kernel edge_detection(read_only image2d_t in_pic, write_only image2d_t out_pic) { // a same image cannot be rw
    float4 n_pixel = (float4){0.0f, 0.0f, 0.0f, 0.0f};

    #pragma unroll
    for (int i=0; i<3; i++) {
        #pragma unroll
        for (int j=0; j<3; j++) {
            n_pixel += read_imagef(in_pic, ed_sampler, (int2){get_global_id(0)+i-1, get_global_id(1)+j-1}) * ck_ed[i+(j*3)];
        }
    }

    float n_singlechannel_pixel = (n_pixel.x + n_pixel.y + n_pixel.z) / 3.0f;

    //n_singlechannel_pixel = n_singlechannel_pixel < .2f ? 0.0f : n_singlechannel_pixel;

    write_imagef(out_pic, (int2){get_global_id(0), get_global_id(1)}, n_singlechannel_pixel);
}
