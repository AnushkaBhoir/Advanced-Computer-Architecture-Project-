struct metadata {
    int entry_format;
    uint8_t branch_type;
    int branch_delta;
    int target_delta;
    uint64_t full_addr;

    metadata() : entry_format(0), branch_type(0), branch_delta(0), target_delta(0) {}
};