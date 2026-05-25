if [ ! -f "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" ]; then
    LOG_STEP_IN "- Extracting libbluetooth_jni.so from com.android.bt.apex"

    if [ -d "$TMP_DIR" ]; then
        EVAL "rm -rf \"$TMP_DIR\""
    fi
    mkdir -p "$TMP_DIR"

    EVAL "unzip -j \"$WORK_DIR/system/system/apex/com.android.bt.apex\" \"apex_payload.img\" -d \"$TMP_DIR\""

    if ! sudo -n -v &> /dev/null; then
        LOG "\033[0;33m! Asking user for sudo password\033[0m"
        if ! sudo -v 2> /dev/null; then
            ABORT "Root permissions are required to unpack APEX image"
        fi
    fi

    mkdir -p "$TMP_DIR/tmp_out"
    EVAL "sudo mount -o ro \"$TMP_DIR/apex_payload.img\" \"$TMP_DIR/tmp_out\""
    EVAL "sudo cat \"$TMP_DIR/tmp_out/lib64/libbluetooth_jni.so\" > \"$WORK_DIR/system/system/lib64/libbluetooth_jni.so\""

    EVAL "sudo umount \"$TMP_DIR/tmp_out\""
    rm -rf "$TMP_DIR"

    SET_METADATA "system" "system/lib64/libbluetooth_jni.so" 0 0 644 "u:object_r:system_lib_file:s0"

    LOG_STEP_OUT
fi

# Disable VaultKeeper support
<<<<<<< HEAD
# Before: [tbnz w8, #0, #0xbd260]
# After: [b #0xbd260]
HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
    "2897773948050037" "289777392a000014"
=======
# Before: [tbnz w8, #0, #0xXXXXXX]
# After: [b #0xXXXXXX]
# S22
if xxd -p -c 0 "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" | grep -q "2897773948050037"; then
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "2897773948050037" "289777392a000014"
elif xxd -p -c 0 "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" | grep -q "183a009048050037"; then
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "183a009048050037" "183a00902a000014"
# S23
elif xxd -p -c 0 "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" | grep -q "e8060034"; then
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "e8060034" "37000014"
else
    ABORT "No known patch available for the supplied libbluetooth_jni.so"
fi
>>>>>>> 018f4a55 (unica: patches: bt-lib-patch: Add HEX_PATCH for S23)
