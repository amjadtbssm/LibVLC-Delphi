  (** \name VLC_COMMON_MEMBERS
   * these members are common for all vlc objects
   *)
      psz_object_type: PChar;

      (* Messages header *)
      psz_header: PChar;
      i_flags: Integer;

      (* Object properties *)
      b_error: bool;                   (**< set by the object *)
      b_die: bool;                    (**< set by the outside *)
      b_force: bool;       (**< set by the outside (eg. module_need()) *)

      (** Just a reminder so that people don't cast garbage *)
      be_sure_to_add_VLC_COMMON_MEMBERS_to_struct: bool;

      (* Stuff related to the libvlc structure *)
      p_libvlc: Pointer;//Plibvlc_int_t;                   (**< (root of all evil) - 1 *)

      p_parent: Pointer; //Pvlc_object_t;                             (**< our parent *)

