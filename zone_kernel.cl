constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST;

#define YRC 0.2126f
#define YGC 0.7152f
#define YBC 0.0722f

void kernel zone(read_only image2d_t in_pic, write_only image2d_t out_pic) { // a same image cannot be rw
    /*int2 pos = {
        get_global_id(0),
        get_global_id(1)
    };

    float4 pixel = read_imagef(in_pic, sampler, pos);
    float4 pixel_lum = pixel * (float4){YBC, YGC, YRC, 1.0f};

    float y_pixel = pixel_lum.x + pixel_lum.y + pixel_lum.z;

    int i_pixel = (int)(y_pixel * 100.0f) / 10;

    float n_pixel = (float)i_pixel / 10.0f;

    write_imagef(out_pic, pos, n_pixel);*/

    int2 pos = {
        get_global_id(0),
        get_global_id(1)
    };

    float4 pixel = read_imagef(in_pic, sampler, pos);
    float4 pixel_lum = pixel * (float4){YBC, YGC, YRC, 1.0f};

    float4 gamma_up = pow(pixel_lum, 0.455f);
    float4 gamma_down = pow(pixel_lum, 2.21f);

    float gamma_up_y = gamma_up.x + gamma_up.y + gamma_up.z;
    float gamma_down_y = gamma_down.x + gamma_down.y + gamma_down.z;

    float y_pixel = pixel_lum.x + pixel_lum.y + pixel_lum.z;
    y_pixel = (gamma_up_y + gamma_down_y + y_pixel) / 3.0f;

    int i_pixel = (int)(y_pixel * 100.0f) / 10;

    float n_pixel = (float)i_pixel / 10.0f;

    write_imagef(out_pic, pos, n_pixel);
}
