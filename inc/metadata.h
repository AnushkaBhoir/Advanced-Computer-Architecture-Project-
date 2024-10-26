struct metadata {
    uint8_t entry_format;
    uint8_t branch_type;
    uint8_t branch_delta;
    uint8_t target_delta;
    uint64_t full_addr;

    metadata() : entry_format(0), branch_type(0), branch_delta(0), target_delta(0) {}
};