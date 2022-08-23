if (distance_to_point(destinationX, destinationY) < 10) {
   reachedDestination = true;
   speed = 0;
} else if (!reachedDestination) {
   move_towards_point(destinationX, destinationY, moveSpeed);
}

owner_instance.grappling = true;