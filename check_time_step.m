function res = check_time_step(velocity,dt, dz)

should_be = critical_time_step(dz, velocity)/2;
res = should_be - dt;

end