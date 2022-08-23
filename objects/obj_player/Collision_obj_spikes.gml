if (other.image_index = 0 and vspeed >= 0 or
    other.image_index = 1 and hspeed <= 0 or
    other.image_index = 2 and vspeed <= 0 or
    other.image_index = 3 and hspeed >= 0) {
   instance_destroy();
}
