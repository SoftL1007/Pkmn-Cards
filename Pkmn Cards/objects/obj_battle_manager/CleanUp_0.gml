if (variable_global_exists("part_sys")) {
    part_type_destroy(global.pt_aura);
    part_type_destroy(global.pt_poof);
    part_system_destroy(global.part_sys);
}