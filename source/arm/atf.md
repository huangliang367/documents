# ARM Trusted Firmware

# BL1

```c
/* Structure used to create a connection to a type of device */
typedef struct io_dev_connector {
 /* dev_open opens a connection to a particular device driver */
 int (*dev_open)(const uintptr_t dev_spec, io_dev_info_t **dev_info);
} io_dev_connector_t;
```

```c
/* Device info structure, providing device-specific functions and a means of
 * adding driver-specific state */
typedef struct io_dev_info {
 const struct io_dev_funcs *funcs;
 uintptr_t info;
} io_dev_info_t;
```

```c
/* Structure to hold device driver function pointers */
typedef struct io_dev_funcs {
 io_type_t (*type)(void);
 int (*open)(io_dev_info_t *dev_info, const uintptr_t spec,
   io_entity_t *entity);
 int (*seek)(io_entity_t *entity, int mode, signed long long offset);
 int (*size)(io_entity_t *entity, size_t *length);
 int (*read)(io_entity_t *entity, uintptr_t buffer, size_t length,
   size_t *length_read);
 int (*write)(io_entity_t *entity, const uintptr_t buffer,
   size_t length, size_t *length_written);
 int (*close)(io_entity_t *entity);
 int (*dev_init)(io_dev_info_t *dev_info, const uintptr_t init_params);
 int (*dev_close)(io_dev_info_t *dev_info);
} io_dev_funcs_t;
```

```c
/* Generic IO entity structure,representing an accessible IO construct on the
 * device, such as a file */
typedef struct io_entity {
 struct io_dev_info *dev_handle;
 uintptr_t info;
} io_entity_t;
```

devices 中记录所有IO设备：

```c
static const io_dev_info_t *devices[MAX_IO_DEVICES];
```

返回对应设备的io_dev_info_t结构体。

```c
static int fip_dev_open(const uintptr_t dev_spec,
    io_dev_info_t **dev_info)
```

```c
struct plat_io_policy {
 uintptr_t *dev_handle;
 uintptr_t image_spec;
 int (*check)(const uintptr_t spec);
};
```

```c
/*****************************************************************************
 * The image descriptor struct definition.
 *****************************************************************************/
typedef struct image_desc {
 /* Contains unique image id for the image. */
 unsigned int image_id;
 /*
  * This member contains Image state information.
  * Refer IMAGE_STATE_XXX defined above.
  */
 unsigned int state;
 uint32_t copied_size; /* image size copied in blocks */
 image_info_t image_info;
 entry_point_info_t ep_info;
} image_desc_t;
```

devices[0] = io_dev_info_t fip
devices[1] = static io_dev_info_t memmap_dev_info

policy = FCONF_GET_PROPERTY(arm, io_policies, image_id);
arm__io_policies_getter(image_id)

```c
/* By default, ARM platforms load images from the FIP */
static const struct plat_io_policy policies[] = {
 [FIP_IMAGE_ID] = {
  &memmap_dev_handle,
  (uintptr_t)&fip_block_spec,
  open_memmap
 },
 [ENC_IMAGE_ID] = {
  &fip_dev_handle,
  (uintptr_t)NULL,
  open_fip
 },
 [BL2_IMAGE_ID] = {
  &fip_dev_handle,
  (uintptr_t)&bl2_uuid_spec,
  open_fip
 },
#if ENCRYPT_BL31 && !defined(DECRYPTION_SUPPORT_none)
 [BL31_IMAGE_ID] = {
  &enc_dev_handle,
  (uintptr_t)&bl31_uuid_spec,
  open_enc_fip
 },
#else
 [BL31_IMAGE_ID] = {
  &fip_dev_handle,
  (uintptr_t)&bl31_uuid_spec,
  open_fip
 },
#endif
#if ENCRYPT_BL32 && !defined(DECRYPTION_SUPPORT_none)
 [BL32_IMAGE_ID] = {
  &enc_dev_handle,
  (uintptr_t)&bl32_uuid_spec,
  open_enc_fip
 },
 [BL32_EXTRA1_IMAGE_ID] = {
  &enc_dev_handle,
  (uintptr_t)&bl32_extra1_uuid_spec,
  open_enc_fip
 },
 [BL32_EXTRA2_IMAGE_ID] = {
  &enc_dev_handle,
  (uintptr_t)&bl32_extra2_uuid_spec,
  open_enc_fip
 },
#else
 [BL32_IMAGE_ID] = {
  &fip_dev_handle,
  (uintptr_t)&bl32_uuid_spec,
  open_fip
 },
 [BL32_EXTRA1_IMAGE_ID] = {
  &fip_dev_handle,
  (uintptr_t)&bl32_extra1_uuid_spec,
  open_fip
 },
 [BL32_EXTRA2_IMAGE_ID] = {
  &fip_dev_handle,
  (uintptr_t)&bl32_extra2_uuid_spec,
  open_fip
 },
#endif
 [TB_FW_CONFIG_ID] = {
  &fip_dev_handle,
  (uintptr_t)&tb_fw_config_uuid_spec,
  open_fip
 },
 [TOS_FW_CONFIG_ID] = {
  &fip_dev_handle,
  (uintptr_t)&tos_fw_config_uuid_spec,
  open_fip
 },
 [BL33_IMAGE_ID] = {
  &fip_dev_handle,
  (uintptr_t)&bl33_uuid_spec,
  open_fip
 },
 [RMM_IMAGE_ID] = {
  &fip_dev_handle,
  (uintptr_t)&rmm_uuid_spec,
  open_fip
 },

#if TRUSTED_BOARD_BOOT
 [TRUSTED_BOOT_FW_CERT_ID] = {
  &fip_dev_handle,
  (uintptr_t)&tb_fw_cert_uuid_spec,
  open_fip
 },
 [TRUSTED_KEY_CERT_ID] = {
  &fip_dev_handle,
  (uintptr_t)&trusted_key_cert_uuid_spec,
  open_fip
 },
 [SOC_FW_KEY_CERT_ID] = {
  &fip_dev_handle,
  (uintptr_t)&soc_fw_key_cert_uuid_spec,
  open_fip
 },
 [TRUSTED_OS_FW_KEY_CERT_ID] = {
  &fip_dev_handle,
  (uintptr_t)&tos_fw_key_cert_uuid_spec,
  open_fip
 },
 [NON_TRUSTED_FW_KEY_CERT_ID] = {
  &fip_dev_handle,
  (uintptr_t)&nt_fw_key_cert_uuid_spec,
  open_fip
 },
 [SOC_FW_CONTENT_CERT_ID] = {
  &fip_dev_handle,
  (uintptr_t)&soc_fw_cert_uuid_spec,
  open_fip
 },
 [TRUSTED_OS_FW_CONTENT_CERT_ID] = {
  &fip_dev_handle,
  (uintptr_t)&tos_fw_cert_uuid_spec,
  open_fip
 },
 [NON_TRUSTED_FW_CONTENT_CERT_ID] = {
  &fip_dev_handle,
  (uintptr_t)&nt_fw_cert_uuid_spec,
  open_fip
 },
#endif /* TRUSTED_BOARD_BOOT */
};
```