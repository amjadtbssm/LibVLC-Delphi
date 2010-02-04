unit LibVlcObject;

(*****************************************************************************
 * libvlc.h:  libvlc external API
 *****************************************************************************
 * Copyright (C) 2010 Pierre de La Tullaye
 *
 * Authors: Pierre de la Tullaye
 *
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the Lesser GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the Lesser GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *
 * http://www.gnu.org/licenses/lgpl-3.0.txt
 *****************************************************************************)

interface
uses
  Windows, Libvlc;

type
  TVLCObject = class

  end;

  TVLCException = class(TVLCObject)
  Private
    FException : libvlc_exception_t;
  protected
    (**
     * Initialize an exception structure. This can be called several times to
     * reuse an exception structure.
     *
     * \param p_exception the exception to initialize
     *)
    procedure init;

    (**
     * Has an exception been raised?
     *
     * \param p_exception the exception to query
     * \return 0 if the exception was raised, 1 otherwise
     *)

    function raised:longbool;

    (**
     * Raise an exception.
     *
     * \param p_exception the exception to raise
     *)
    procedure RaiseException;

    (**
     * Clear an exception object so it can be reused.
     * The exception object must have be initialized.
     *
     * \param p_exception the exception to clear
     *)
    procedure clear;

    (**
     * Get an exception's message.
     *
     * \param p_exception the exception to query
     * \return the exception message or NULL if not applicable (exception not
     *         raised, for example)
     *)
    function get_message:UTF8String;
  Public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Check;
  end;

  TVLCEventManager = class(TVLCObject)
  private
    FEvent : Plibvlc_event_manager_t;
    FException : TVLCException;
  protected
    (**
     * Register for an event notification.
     *
     * \param i_event_type the desired event to which we want to listen
     * \param f_callback the function to call when i_event_type occurs
     * \param user_data user provided data to carry with the event
     *)
    procedure attach  ( i_event_type: libvlc_event_type_t;
                        f_callback: libvlc_callback_t;
                        user_data: Pointer);

    (**
     * Unregister an event notification.
     *
     * \param i_event_type the desired event to which we want to unregister
     * \param f_callback the function to call when i_event_type occurs
     * \param p_user_data user provided data to carry with the event
     *)
     procedure detach ( i_event_type: libvlc_event_type_t;
                        f_callback: libvlc_callback_t;
                        p_user_data: Pointer);


  Public
    Constructor Create (aEvent : Plibvlc_event_manager_t);
  end;

  TVlcLogIterator = class(TVLCObject)
  private
    FIter : Plibvlc_log_iterator_t;
    FException : TVLCException;
  Public
    {$REGION 'Internal'}
    (**
     * Release a previoulsy allocated iterator.
     *
     * \param p_iter libvlc log iterator or NULL
     *)
    procedure freeIterator;

    (**
     * Return whether log iterator has more messages.
     *
     * \param p_iter libvlc log iterator or NULL
     * \return true if iterator has more message objects, else false
     *)
    function has_next:Longbool;

    (**
     * Return the next log message.
     *
     * The message contents must not be freed
     *
     * \param p_iter libvlc log iterator or NULL
     * \param p_buffer log buffer
     * \param p_e an initialized exception pointer
     * \return log message object
     *)
    function next  ( p_buffer: Plibvlc_log_message_t):Plibvlc_log_message_t;


    {$ENDREGION}
  Public
    Constructor Create(aIter : Plibvlc_log_iterator_t);
    destructor Destroy; override;
  end;

  TVlcLog = class(TVLCObject)
  private
    FLog : Plibvlc_log_t;
    FException : TVLCException;
  Public
    {$REGION 'Internal'}
    (**
     * Close a VLC message log instance.
     *
     * \param p_log libvlc log instance or NULL
     *)
    procedure close;

    (**
     * Returns the number of messages in a log instance.
     *
     * \param p_log libvlc log instance or NULL
     * \return number of log messages, 0 if p_log is NULL
     *)
    function count:longword;

    (**
     * Clear a log instance.
     *
     * All messages in the log are removed. The log should be cleared on a
     * regular basis to avoid clogging.
     *
     * \param p_log libvlc log instance or NULL
     *)
    procedure clear;

    (**
     * Allocate and returns a new iterator to messages in log.
     *
     * \param p_log libvlc log instance
     * \param p_e an initialized exception pointer
     * \return log iterator object
     *)
    function get_iterator:TVlcLogIterator;

    {$ENDREGION}
  public
    Constructor Create (aLog : Plibvlc_log_t);
    Destructor Destroy; override;
  end;

  TVLCMediaList = class;
  TVLCMediaPlayer = class;

  TVLCMedia = class(TVLCObject)
  Private
    FMedia : Plibvlc_media_t;
    FException : TVLCException;
  Public
    {$region 'internal'}
    (**
     * Create a Media Player object from a Media
     *
     *)
    function player_new_from_media: TVLCMediaPlayer;
    (**
     * Add an option to the media.
     *
     * This option will be used to determine how the media_player will
     * read the media. This allows to use VLC's advanced
     * reading/streaming options on a per-media basis.
     *
     * The options are detailed in vlc --long-help, for instance "--sout-all"
     *
     * \param ppsz_options the options (as a string)
     *)
    procedure add_option ( ppsz_options: UTF8String);

    (**
     * Add an option to the media from an untrusted source.
     *
     * This option will be used to determine how the media_player will
     * read the media. This allows to use VLC's advanced
     * reading/streaming options on a per-media basis.
     *
     * The options are detailed in vlc --long-help, for instance "--sout-all"
     *
     * \param ppsz_options the options (as a string)
     *)
    procedure add_option_untrusted( ppsz_options: PAnsiChar);
    (**
     * Add an option to the media with configurable flags.
     *
     * This option will be used to determine how the media_player will
     * read the media. This allows to use VLC's advanced
     * reading/streaming options on a per-media basis.
     *
     * The options are detailed in vlc --long-help, for instance "--sout-all"
     *
     * \param ppsz_options the options (as a string)
     * \param i_flags the flags for this option
     *)
    procedure add_option_flag ( ppsz_options: UTF8String;
                                       i_flags: libvlc_media_option_t);


    (**
     * Retain a reference to a media descriptor object (libvlc_media_t). Use
     * libvlc_media_release() to decrement the reference count of a
     * media descriptor object.
     *
     *)
   procedure retain ;

    (**
     * Decrement the reference count of a media descriptor object. If the
     * reference count is 0, then libvlc_media_release() will release the
     * media descriptor object. It will send out an libvlc_MediaFreed event
     * to all listeners. If the media descriptor object has been released it
     * should not be used again.
     *
     *)
   procedure release;


    (**
     * Get the media resource locator (mrl) from a media descriptor object
     *
     * \return string with mrl of media descriptor object
     *)
    function get_mrl:UTF8String;

    (**
     * Duplicate a media descriptor object.
     *
     *)
    function duplicate:TVLCMedia;

    (**
     * Read the meta of the media.
     *
     * \param e_meta the meta to read
     * \return the media's meta
     *)
    function get_meta ( e_meta: libvlc_meta_t):UTF8String;

    (**
     * Get current state of media descriptor object. Possible media states
     * are defined in libvlc_structures.c ( libvlc_NothingSpecial=0,
     * libvlc_Opening, libvlc_Buffering, libvlc_Playing, libvlc_Paused,
     * libvlc_Stopped, libvlc_Ended,
     * libvlc_Error).
     *
     * @see libvlc_state_t
     * \param p_meta_desc a media descriptor object
     *)
    function get_state :libvlc_state_t;


    (**
     * Get subitems of media descriptor object. This will increment
     * the reference count of supplied media descriptor object. Use
     * libvlc_media_list_release() to decrement the reference counting.
     *
     * \return list of media descriptor subitems or NULL
     *)

    (* This method uses libvlc_media_list_t, however, media_list usage is optionnal
     * and this is here for convenience *)
    //#define VLC_FORWARD_DECLARE_OBJECT(a) struct a

   function subitems : TVLCMediaList; //Plibvlc_media_list_t;

    (**
     * Get event manager from media descriptor object.
     * NOTE: this function doesn't increment reference counting.
     *
     * \return event manager object
     *)

   function event_manager :TVLCEventManager;

    (**
     * Get duration (in ms) of media descriptor object item.
     *
     * \return duration of media item
     *)

   function get_duration :libvlc_time_t;

    (**
     * Get preparsed status for media descriptor object.
     *
     * \return true if media object has been preparsed otherwise it returns false
     *)
   function is_preparsed :longbool;

    (**
     * Sets media descriptor's user_data. user_data is specialized data
     * accessed by the host application, VLC.framework uses it as a pointer to
     * an native object that references a libvlc_media_t pointer
     *
     *)
   procedure set_user_data (p_new_user_data: Pointer);

    (**
     * Get media descriptor's user_data. user_data is specialized data
     * accessed by the host application, VLC.framework uses it as a pointer to
     * an native object that references a libvlc_media_t pointer
     *
     *)
    function get_user_data :Pointer ;
    {$endregion}
  Public
    Constructor Create(aMedia : Plibvlc_media_t);
    destructor Destroy; override;

    property State : libvlc_state_t read get_state;
    property Duration : libvlc_time_t read get_duration;
    property Preparsed : longbool read is_preparsed;

    property MetaData[e_meta: libvlc_meta_t] : UTF8String read get_meta;
    property UserData : Pointer read Get_user_data write set_user_data;
  end;

  TVLCMediaList = class(TVLCObject)
  Private
    FMedialist : Plibvlc_media_list_t;
    FException : TVLCException;
  Public
    {$REGION 'Internal'}
    (**
     * Release media list created with libvlc_media_list_new().
     *
     *)
    procedure release;

    (**
     * Retain reference to a media list
     *
     *)
    procedure retain;

    //VLC_DEPRECATED_API
    procedure add_file_content  ( psz_uri: UTF8String );

    (**
     * Associate media instance with this media list instance.
     * If another media instance was present it will be released.
     * The libvlc_media_list_lock should NOT be held upon entering this function.
     *
     * \param p_mi media instance to add
     *)
    procedure set_media ( media: TVLCMedia);

    (**
     * Get media instance from this media list instance. This action will increase
     * the refcount on the media instance.
     * The libvlc_media_list_lock should NOT be held upon entering this function.
     *
     * \return media instance
     *)
    function media:TVLCMedia;

    (**
     * Add media instance to media list
     * The libvlc_media_list_lock should be held upon entering this function.
     *
     * \param p_mi a media instance
     *)
    procedure add_media  ( media: TVLCMedia);

    (**
     * Insert media instance in media list on a position
     * The libvlc_media_list_lock should be held upon entering this function.
     *
     * \param p_mi a media instance
     * \param i_pos position in array where to insert
     *)
    procedure insert_media ( media: TVLCMedia; i_pos: Integer);
    (**
     * Remove media instance from media list on a position
     * The libvlc_media_list_lock should be held upon entering this function.
     *
     * \param i_pos position in array where to insert
     *)
    procedure remove_index ( i_pos: Integer);

    (**
     * Get count on media list items
     * The libvlc_media_list_lock should be held upon entering this function.
     *
     * \return number of items in media list
     *)
    function Getcount:integer;

    (**
     * List media instance in media list at a position
     * The libvlc_media_list_lock should be held upon entering this function.
     *
     * \param i_pos position in array where to insert
     * \return media instance at position i_pos and libvlc_media_retain() has been called to increase the refcount on this object.
     *)
    function item_at_index ( i_pos: Integer):TVLCMedia;
    (**
     * Find index position of List media instance in media list.
     * Warning: the function will return the first matched position.
     * The libvlc_media_list_lock should be held upon entering this function.
     *
     * \param p_mi media list instance
     * \return position of media instance
     *)
    function index_of_item  ( media: TVLCMedia):integer;

    (**
     * This indicates if this media list is read-only from a user point of view
     *
     * \return 0 on readonly, 1 on readwrite
     *)
    function is_readonly:longbool;

    (**
     * Get lock on media list items
     *
     *)
    procedure lock;

    (**
     * Release lock on media list items
     * The libvlc_media_list_lock should be held upon entering this function.
     *
     *)
    procedure unlock;

    (**
     * Get a flat media list view of media list items
     *
     * \return flat media list view instance
     *)
    function flat_view:Plibvlc_media_list_view_t;

    (**
     * Get a hierarchical media list view of media list items
     *
     * \return hierarchical media list view instance
     *)
    function hierarchical_view:Plibvlc_media_list_view_t;


    function hierarchical_node_view:Plibvlc_media_list_view_t;

    (**
     * Get libvlc_event_manager from this media list instance.
     * The p_event_manager is immutable, so you don't have to hold the lock
     *
     * \return libvlc_event_manager
     *)
    function event_manager:TVLCEventManager;
    {$ENDREGION}
  public
    Constructor Create(aML : Plibvlc_media_list_t);
    Destructor Destroy; override;

    property ReadOnly : longbool read is_readonly;
    property ItemCount : Integer read GetCount;
    property Item[ i_pos: Integer]: TVLCMedia read item_at_index;
  end;

  TVLCMediaLibrary = class(TVLCObject)
  Private
    FLibrary : Plibvlc_media_library_t;
    FException : TVLCException;
  Public
    {$REGION 'internal'}
    (**
     * Release media library object. This functions decrements the
     * reference count of the media library object. If it reaches 0,
     * then the object will be released.
     *
     *)
    procedure release;

    (**
     * Retain a reference to a media library object. This function will
     * increment the reference counting for this object. Use
     * libvlc_media_library_release() to decrement the reference count.
     *
     *)
    procedure retain;

    (**
     * Load media library.
     *
     *)
    procedure load;
    (**
     * Save media library.
     *
     *)
    procedure save;

    (**
     * Get media library subitems.
     *
     * \return media list subitems
     *)
    function media_list:TVLCMediaList;


    {$ENDREGION}
  Public
    Constructor Create (aLibrary : Plibvlc_media_library_t);
    Destructor Destroy; override;
  end;

  TVLCMediaPlayer = class(TVLCObject)
  private
    FPlayer : Plibvlc_media_player_t;
    FException : TVLCException;
  Public
    {$region 'internal'}
    procedure retain;
    procedure set_media ( media: TVLCMedia  );
    function  get_media :TVLCMedia;
    function  event_manager :TVLCEventManager;

    function  is_playing :longbool;

    procedure set_nsobject ( drawable: Pointer);
    function  get_nsobject :Pointer;

    procedure set_agl ( drawable: uint32);
    function  get_agl :uint32;
    {$IFDEF LINUX}
    procedure set_xwindow ( drawable: uint32);
    function  get_xwindow :uint32;
    {$ENDIF}
    {$IFDEF WIN32}
    procedure set_hwnd ( drawable: THandle);
    function  get_hwnd :THandle;
    {$ENDIF}

    function  get_length :libvlc_time_t;
    function  get_time :libvlc_time_t;
    procedure set_time ( time: libvlc_time_t);
    function  get_position: Single;
    procedure set_position ( f_pos: Single);

    function  will_play :longbool;

    procedure set_chapter ( i_chapter: Integer);
    function  get_chapter :integer;
    function  get_chapter_count:integer;
    function  get_chapter_count_for_title ( i_title: Integer):integer;

    procedure set_title ( i_title: Integer);
    function  get_title:integer;
    function  get_title_count :integer;

    procedure previous_chapter;
    procedure next_chapter;

    function  get_rate:single;
    procedure set_rate ( rate: Single);

    function  get_state :libvlc_state_t;

    function  get_fps :single;
    function  has_vout :longbool;
    function  is_seekable :longbool;
    function  can_pause :longbool;
    procedure next_frame ;

    procedure set_fullscreen ( b_fullscreen: LongBool);
    function  get_fullscreen :longbool;

    procedure video_set_key_input ( _on: Cardinal);
    procedure Video_set_mouse_input ( _on: Cardinal);

    function  Video_get_height :integer;
    function  Video_get_width :integer;

    function  Video_get_scale :single;
    procedure Video_set_scale (  i_factor: Single);

    function  Video_get_aspect_ratio :UTF8String;
    procedure Video_set_aspect_ratio  (  psz_aspect: UTF8String);

    function  video_get_spu :integer;
    procedure video_set_spu (  i_spu: Integer);
    function  video_get_spu_count :integer;
    function  video_get_spu_description :Plibvlc_track_description_t;

    function  video_set_subtitle_file (  psz_subtitle: UTF8String):integer;

    function  video_get_title_description :Plibvlc_track_description_t;

    function  video_get_chapter_description (  i_title: Integer):Plibvlc_track_description_t;

    function  Video_get_crop_geometry :UTF8String;
    procedure Video_set_crop_geometry (  psz_geometry: UTF8String);

    procedure toggle_teletext ;
    function  video_get_teletext :integer;
    procedure video_set_teletext (  i_page: Integer);

    function  video_get_track_count :integer;
    function  video_get_track :integer;
    procedure video_set_track (  i_track: Integer);
    function  video_get_track_description :Plibvlc_track_description_t;

    procedure video_take_snapshot ( psz_filepath: UTF8String;
                              i_width: Cardinal;
                              i_height: Cardinal );

    procedure video_set_deinterlace ( b_enable: Integer; psz_mode: UTF8String);
    function  Video_get_marquee_option_as_int ( option: libvlc_video_marquee_int_option_t):integer;
    function  Video_get_marquee_option_as_string ( option: libvlc_video_marquee_string_option_t):UTF8String;
    procedure Video_set_marquee_option_as_int ( option : libvlc_video_marquee_int_option_t; i_val: Integer);
    procedure Video_set_marquee_option_as_string ( option: libvlc_video_marquee_string_option_t; psz_text: UTF8String );
    {$endregion}
  Public
    Constructor Create( aPlayer : Plibvlc_media_player_t);
    destructor Destroy; override;

    procedure play;
    procedure pause;
    procedure stop;
    procedure release;

    procedure toggle_fullscreen ;

    property IsPlaying : longbool read is_playing;
    property WillPlay : longbool read will_play;

    property hwnd : THandle read get_hwnd write set_hwnd;

    property Duration : libvlc_time_t read get_length;
    property Time : libvlc_time_t read get_time write set_time;
    property Position : Single read get_position write set_position;

    property ChapterCount : integer read get_chapter_count;
    property Chapter : Integer read get_chapter write set_chapter;

    property Rate : Single read get_rate write set_rate;

    Property TitleCount : integer read get_title_count;
    property Title : Integer read get_title write set_title;

    property CurrentMedia :TVLCMedia read get_media write set_media;
    property nsobject : Pointer read get_nsobject write set_nsobject;
    property agl : uint32 read get_agl write set_agl;

    property FullScreen : longbool read get_fullscreen write set_fullscreen;

    property VideoScale:Single read Video_get_scale write Video_set_scale;
    property VideoAscpectRatio : UTF8String read Video_get_aspect_ratio write Video_set_aspect_ratio;

    property VideoHeight : Integer read Video_get_height;
    property VideoWidth : Integer read Video_get_width;

    property VideoTrackCount : Integer read video_get_track_count;
    property VideoTrack : integer read  video_get_track write video_set_track;


    property State:libvlc_state_t  read get_state;

    property fps: single read get_fps;
    property HasVout : longbool read has_vout;
    property IsSeekable : longbool read is_seekable;
    property CanPause: longbool read can_pause;
  end;



  TVLCInstance = class(TVLCObject)
  Private
    FInstance : Plibvlc_instance_t;
    FException : TVLCException;
    FVersion : UTF8String;
  Public
    {$REGION 'internal'}

    function new:TVLCMediaPlayer;
    //function new_from_media:TMediaPlayer;

    (**
     * Decrement the reference count of a libvlc instance, and destroy it
     * if it reaches zero.
     *
     *)
    procedure release;

    (**
     * Increments the reference count of a libvlc instance.
     * The initial reference count is 1 after libvlc_new() returns.
     *
     *)
    procedure retain;

    (**
     * Try to start a user interface for the libvlc instance.
     *
     * \param name interface name, or NULL for default
     * \return 0 on success, -1 on error.
     *)

    function add_intf ( name: UTF8String):integer;

    (**
     * Waits until an interface causes the instance to exit.
     * You should start at least one interface first, using libvlc_add_intf().
     *
     *)
   procedure wait ;

    (**
     * Return the VLC messaging verbosity level.
     *
     * \return verbosity level for messages
     *)
    function get_log_verbosity :longword;

    (**
     * Set the VLC messaging verbosity level.
     *
     * \param level log level
     *)
    procedure set_log_verbosity( level: Cardinal);

    (**
     * Open a VLC message log instance.
     *
     * \return log message instance
     *)
    function log_open:TVlcLog;

    (**
     * Create a media with the given MRL.
     *
     * \param psz_mrl the MRL to read
     * \return the newly created media
     *)
    function  media_new   ( const psz_mrl: UTF8String):TVLCMedia;

    (**
     * Create a media as an empty node with the passed name.
     *
     * \param psz_name the name of the node
     * \return the new empty media
     *)
   function  media_new_as_node   ( psz_name: UTF8String):TVLCMedia;

    (**
     * Create an empty Media Player object
     *
     *)
    function media_player_new:TVLCMediaPlayer;

    (**
     * Get the list of available audio outputs
     *
     * \return list of available audio outputs, at the end free it with
     *          \see libvlc_audio_output_list_release \see libvlc_audio_output_t
     *)
    function audio_output_list_get :Plibvlc_audio_output_t;
    (**
     * Set the audio output.
     * Change will be applied after stop and play.
     *
     * \param psz_name name of audio output,
     *               use psz_name of \see libvlc_audio_output_t
     * \return true if function succeded
     *)
    function audio_output_set ( psz_name: UTF8String):integer;

    (**
     * Get count of devices for audio output, these devices are hardware oriented
     * like analor or digital output of sound card
     *
     * \param psz_audio_output - name of audio output, \see libvlc_audio_output_t
     * \return number of devices
     *)
    function audio_output_device_count ( psz_audio_output: UTF8String):integer;

    (**
     * Get long name of device, if not available short name given
     *
     * \param psz_audio_output - name of audio output, \see libvlc_audio_output_t
     * \param i_device device index
     * \return long name of device
     *)
    function audio_output_device_longname ( psz_audio_output: UTF8String;
                                                   i_device: Integer):UTF8String;

    (**
     * Get id name of device
     *
     * \param psz_audio_output - name of audio output, \see libvlc_audio_output_t
     * \param i_device device index
     * \return id name of device, use for setting device, need to be free after use
     *)
    function audio_output_device_id ( psz_audio_output: UTF8String;
                                             i_device: Integer):UTF8String;

    (**
     * Set device for using
     *
     * \param psz_audio_output - name of audio output, \see libvlc_audio_output_t
     * \param psz_device_id device
     *)
    procedure audio_output_device_set ( psz_audio_output: UTF8String;
                                          psz_device_id: UTF8String);

    (**
     * Get current audio device type. Device type describes something like
     * character of output sound - stereo sound, 2.1, 5.1 etc
     *
     * \return the audio devices type \see libvlc_audio_output_device_types_t
     *)
   function audio_output_get_device_type :integer;

    (**
     * Set current audio device type.
     *
     * \param device_type the audio device type,
              according to \see libvlc_audio_output_device_types_t
     *)
   procedure audio_output_set_device_type ( device_type: Integer);


    (**
     * Toggle mute status.
     *
     *)
   procedure audio_toggle_mute ;

    (**
     * Get current mute status.
     *
     * \return the mute status (boolean)
     *)
   function audio_get_mute:longbool;

    (**
     * Set mute status.
     *
     * \param status If status is true then mute, otherwise unmute
     *)
   procedure audio_set_mute ( status: longbool);

    (**
     * Get current audio level.
     *
     * \return the audio level (int)
     *)
   function audio_get_volume :integer; cdecl;

    (**
     * Set current audio level.
     *
     * \param i_volume the volume (int)
     *)
   procedure audio_set_volume (i_volume: Integer);

    (**
     * Get current audio channel.
     *
     * \return the audio channel \see libvlc_audio_output_channel_t
     *)
    function audio_get_channel:integer;

    (**
     * Set current audio channel.
     *
     * \param channel the audio channel, \see libvlc_audio_output_channel_t
     *)
    procedure audio_set_channel ( channel: Integer);

    (**
     * Create an empty media list.
     *
     * \return empty media list
     *)
    function media_list_new :TVLCMediaList; // Plibvlc_media_list_t;

    (**
     * Create new media_list_player.
     *
     * \return media list player instance
     *)
    function media_list_player_new:Plibvlc_media_list_player_t;

    (**
     * Create an new Media Library object
     *
     *)
    function media_library_new:TVLCMediaLibrary;
    (**
     * Discover media service by name.
     *
     * \param psz_name service name
     * \return media discover object
     *)

    function media_discoverer_new_from_name ( psz_name: UTF8String
                                           ):Plibvlc_media_discoverer_t;

    {$REGION 'vlm'}
    (**
     * Release the vlm instance related to the given libvlc_instance_t
     *
     *)
    procedure vlm_release ; cdecl;

    (**
     * Add a broadcast, with one input.
     *
     * \param psz_name the name of the new broadcast
     * \param psz_input the input MRL
     * \param psz_output the output MRL (the parameter to the "sout" variable)
     * \param i_options number of additional options
     * \param ppsz_options additional options
     * \param b_enabled boolean for enabling the new broadcast
     * \param b_loop Should this broadcast be played in loop ?
     *)
    procedure vlm_add_broadcast ( psz_name: UTF8String;
                                         psz_input: UTF8String;
                                         psz_output: UTF8String;
                                         i_options: Integer;
                                         ppsz_options: array of UTF8String;
                                         b_enabled: Integer;
                                         b_loop: Integer );

    (**
     * Add a vod, with one input.
     *
     * \param psz_name the name of the new vod media
     * \param psz_input the input MRL
     * \param i_options number of additional options
     * \param ppsz_options additional options
     * \param b_enabled boolean for enabling the new vod
     * \param psz_mux the muxer of the vod media
     *)
    procedure vlm_add_vod ( psz_name: UTF8String;
                                   psz_input: UTF8String;
                                   i_options: Integer;
                                   ppsz_options: array of UTF8String;
                                   b_enabled: Integer;
                                   psz_mux: UTF8String  );

    (**
     * Delete a media (VOD or broadcast).
     *
     * \param psz_name the media to delete
     *)
    procedure vlm_del_media ( psz_name: UTF8String);

    (**
     * Enable or disable a media (VOD or broadcast).
     *
     * \param psz_name the media to work on
     * \param b_enabled the new status
     *)
   procedure vlm_set_enabled ( psz_name: UTF8String;
                                       b_enabled: Integer);

    (**
     * Set the output for a media.
     *
     * \param psz_name the media to work on
     * \param psz_output the output MRL (the parameter to the "sout" variable)
     *)
    procedure vlm_set_output ( psz_name: UTF8String;
                                      psz_output:UTF8String );

    (**
     * Set a media's input MRL. This will delete all existing inputs and
     * add the specified one.
     *
     * \param psz_name the media to work on
     * \param psz_input the input MRL
     *)
    procedure vlm_set_input ( psz_name: UTF8String;
                                     psz_input: UTF8String);

    (**
     * Add a media's input MRL. This will add the specified one.
     *
     * \param psz_name the media to work on
     * \param psz_input the input MRL
     *)
    procedure vlm_add_input ( psz_name: UTF8String;
                                     psz_input: UTF8String);
    (**
     * Set a media's loop status.
     *
     * \param psz_name the media to work on
     * \param b_loop the new status
     *)
    procedure vlm_set_loop ( psz_name: UTF8String;
                                    b_loop: Integer);

    (**
     * Set a media's vod muxer.
     *
     * \param psz_name the media to work on
     * \param psz_mux the new muxer
     *)
    procedure vlm_set_mux ( psz_name: UTF8String;
                                   psz_mux: UTF8String);

    (**
     * Edit the parameters of a media. This will delete all existing inputs and
     * add the specified one.
     *
     * \param psz_name the name of the new broadcast
     * \param psz_input the input MRL
     * \param psz_output the output MRL (the parameter to the "sout" variable)
     * \param i_options number of additional options
     * \param ppsz_options additional options
     * \param b_enabled boolean for enabling the new broadcast
     * \param b_loop Should this broadcast be played in loop ?
     *)
    procedure vlm_change_media( psz_name: UTF8String;
                                                 psz_input: UTF8String;
                                                 psz_output: UTF8String;
                                                 i_options: Integer;
                                                 ppsz_options: PPAnsiChar;
                                                 b_enabled: Integer;
                                                 b_loop: Integer);

    (**
     * Play the named broadcast.
     *
     * \param psz_name the name of the broadcast
     *)
    procedure vlm_play_media  ( psz_name: UTF8String);

    (**
     * Stop the named broadcast.
     *
     * \param psz_name the name of the broadcast
     *)
    procedure vlm_stop_media  ( psz_name: UTF8String);

    (**
     * Pause the named broadcast.
     *
     * \param psz_name the name of the broadcast
     *)
    procedure vlm_pause_media( psz_name: UTF8String);

    (**
     * Seek in the named broadcast.
     *
     * \param psz_name the name of the broadcast
     * \param f_percentage the percentage to seek to
     *)
    procedure vlm_seek_media ( psz_name: UTF8String; f_percentage: Single);

    (**
     * Return information about the named media as a JSON
     * string representation.
     *
     * This function is mainly intended for debugging use,
     * if you want programmatic access to the state of
     * a vlm_media_instance_t, please use the corresponding
     * libvlc_vlm_get_media_instance_xxx -functions.
     * Currently there are no such functions available for
     * vlm_media_t though.
     *
     * \param psz_name the name of the media,
     *      if the name is an empty string, all media is described
     * \return string with information about named media
     *)
    function vlm_show_media  ( psz_name: UTF8String):UTF8String;

    (**
     * Get vlm_media instance position by name or instance id
     *
     * \param psz_name name of vlm media instance
     * \param i_instance instance id
     * \return position as float
     *)
    function vlm_get_media_instance_position ( psz_name: UTF8String;  i_instance: Integer):single;

    (**
     * Get vlm_media instance time by name or instance id
     *
     * \param psz_name name of vlm media instance
     * \param i_instance instance id
     * \return time as integer
     *)
    function vlm_get_media_instance_time ( psz_name: UTF8String;  i_instance: Integer):integer;

    (**
     * Get vlm_media instance length by name or instance id
     *
     * \param psz_name name of vlm media instance
     * \param i_instance instance id
     * \return length of media item
     *)
    function vlm_get_media_instance_length ( psz_name: UTF8String;  i_instance: Integer):integer;

    (**
     * Get vlm_media instance playback rate by name or instance id
     *
     * \param psz_name name of vlm media instance
     * \param i_instance instance id
     * \return playback rate
     *)
    function vlm_get_media_instance_rate ( psz_name: UTF8String;  i_instance: Integer):integer;

    (**
     * Get vlm_media instance title number by name or instance id
     * \bug will always return 0
     * \param psz_name name of vlm media instance
     * \param i_instance instance id
     * \return title as number
     *)
    function vlm_get_media_instance_title ( psz_name: UTF8String;  i_instance: Integer):integer;

    (**
     * Get vlm_media instance chapter number by name or instance id
     * \bug will always return 0
     * \param i_instance instance id
     * \return chapter as number
     *)
    function vlm_get_media_instance_chapter  ( const psz_name: UTF8String;  i_instance: Integer):integer;

    (**
     * Is libvlc instance seekable ?
     * \bug will always return 0
     * \param psz_name name of vlm media instance
     * \param i_instance instance id
     * \return 1 if seekable, 0 if not
     *)
    function vlm_get_media_instance_seekable ( psz_name: UTF8String;  i_instance: Integer):integer;

    (**
     * Get libvlc_event_manager from a vlm media.
     * The p_event_manager is immutable, so you don't have to hold the lock
     *
     * \return libvlc_event_manager
     *)
    function vlm_get_event_manager :TVLCEventManager; cdecl;
    {$ENDREGION}

    {$endregion}
  Public
    Constructor Create;
    destructor Destroy; override;

    property Version : UTF8String Read FVersion;
    property Verbosity : longword read get_log_verbosity;

    property AudioChannel : Integer read audio_get_channel write audio_set_channel;
    property AudioOutputDeviceType : Integer read audio_output_get_device_type write audio_output_set_device_type;

    property Volume : Integer read audio_get_volume write audio_set_volume;
    property Mute : Longbool read audio_get_mute write audio_set_mute;
  end;


  TVLCMediaControlException = class(TVLCObject)
  Private
    FException : Pmediacontrol_Exception;
  Public
    {$REGION 'Internal'}
    (**
     * Instanciate and initialize an exception structure.
     * \return the exception
     *)
     Constructor Create;

    (**
     * Initialize an existing exception structure.
     *)
    procedure init;

    (**
     * Clean up an existing exception structure after use.
     *)
    procedure cleanup;

    (**
     * Free an exception structure created with mediacontrol_exception_create().
     * \return the exception
     *)
    procedure Exception_free;
    {$ENDREGION}
  Public
    procedure Check;
    destructor Destroy; override;
  end;

  TVLCMediaControl = class(TVLCObject)
  Private
    FMediaControl : Pmediacontrol_Instance;
    Fexception: TVLCMediaControlException;
  Public
    {$REGION 'Internal'}
    (**
     * Create a MediaControl instance from an existing libvlc instance
     * \param exception an initialized exception pointer
     * \return a mediacontrol_Instance
     *)
    function new_from_instance(VLC : TVLCInstance):TVLCMediaControl;

    (**
     * Get the associated libvlc instance
     * \return a libvlc instance
     *)
    function get_libvlc_instance:Plibvlc_instance_t;

    (**
     * Get the associated libvlc_media_player
     * \return a libvlc_media_player_t instance
     *)
    function get_media_player:Plibvlc_media_player_t;

    (**
     * Get the current position
     * \param an_origin the position origin
     * \param a_key the position unit
     * \return a mediacontrol_Position
     *)
    function get_media_position ( an_origin: mediacontrol_PositionOrigin;
                             a_key: mediacontrol_PositionKey):Pmediacontrol_Position;

    (**
     * Set the position
     * \param a_position a mediacontrol_Position
     *)
    procedure set_media_position( a_position: Pmediacontrol_Position);

    (**
     * Play the movie at a given position
     * \param a_position a mediacontrol_Position
     *)
    procedure start( a_position: Pmediacontrol_Position);

    (**
     * Pause the movie at a given position
     *)
    procedure pause;

    (**
     * Resume the movie at a given position
     *)
    procedure resume;

    (**
     * Stop the movie at a given position
     *)
    procedure stop;

    (**
     * Exit the player
     *)
    procedure exit;

    (**
     * Set the MRL to be played.
     * \param psz_file the MRL
     *)
    procedure set_mrl ( psz_file: UTF8String);

    (**
     * Get the MRL to be played.
     *)
     function get_mrl:UTF8String;

    (*****************************************************************************
     * A/V functions
     *****************************************************************************)
    (**
     * Get a snapshot
     * \param a_position the desired position (ignored for now)
     * \return a RGBpicture
     *)
    function snapshot ( a_position: Pmediacontrol_Position):Pmediacontrol_RGBPicture;


    (**
     *  Displays the message string, between "begin" and "end" positions.
     * \param message the message to display
     * \param begin the begin position
     * \param end the end position
     *)
    procedure display_text ( _message: UTF8String;
                                    _begin: Pmediacontrol_Position;
                                    _end: Pmediacontrol_Position);

    (**
     *  Get information about a stream
     * \param a_key the time unit
     * \return a mediacontrol_StreamInformation
     *)
    function get_stream_information( a_key: mediacontrol_PositionKey):Pmediacontrol_StreamInformation;

    (**
     * Get the current audio level, normalized in [0..100]
     * \param self the mediacontrol instance
     * \return the volume
     *)
    function sound_get_volume:Word;

    (**
     * Set the audio level
     * \param volume the volume (normalized in [0..100])
     *)
    procedure sound_set_volume( volume: Word);

    (**
     * Set the video output window
     * \param visual_id the Xid or HWND, depending on the platform
     *)
    function set_visual ( visual_id: THANDLE):integer;

    (**
     * Get the current playing rate, in percent
     * \return the rate
     *)
    function get_rate:integer;

    (**
     * Set the playing rate, in percent
     * \param rate the desired rate
     *)
    Procedure set_rate ( rate: Integer);

    (**
     * Get current fullscreen status
     * \return the fullscreen status
     *)
    function get_fullscreen:longbool;

    (**
     * Set fullscreen status
     * \param b_fullscreen the desired status
     *)
    procedure set_fullscreen ( b_fullscreen: longbool);
    {$ENDREGION}

  end;

  //////////////////////////////////////////////////////////////////////////////
  ///
  ///
  ///
  ///
  //////////////////////////////////////////////////////////////////////////////

implementation
uses
  Sysutils;


function ArrayOfPAnsiChar(aStrArray : Array of UTF8String):PPAnsiChar;
var
  i : Integer;
  P : PPAnsiChar;
begin
  GetMem(Result,Length(aStrArray)+1);
  P:=@Result;
  for I := 0 to Length(aStrArray) - 1 do
  begin
    P^:=PAnsiChar(UTF8String(aStrArray[i]));
    inc(P);
  end;
  inc(P);
  P^:=Nil;
end;

{ TVLCInstance }

{$REGION 'VLCInstance'}

Constructor TVLCInstance.Create;
Var
  Args: array [0..7] of PAnsiChar;
  i : integer;
begin
  inherited Create;
  VLCLoadLibrary;

  FVersion:=UTF8String(libvlc_get_version);
  (**
   * Create and initialize a libvlc instance.
   *
   * \param argc the number of arguments
   * \param argv command-line-type arguments. argv[0] must be the path of the
   *        calling program.
   * \param p_e an initialized exception pointer
   * \return the libvlc instance
   *)

  FException:=TVLCException.Create;


  FillChar(Args,SizeOf(Args),0);
  i:=0;
  args[i] := PAnsichar(UTF8String('--plugin-path='+AnsiString(VLCLibPath+'plugins\')));
  inc(i);

  //args[i] := PAnsiChar('--no-one-instance'); // make sure plugin isn't affected with VLC single instance mode
  //inc(i);

  (* common settings *)
  args[i] := PAnsiChar('--no-stats');
  inc(i);
  //args[i] := PAnsiChar('--no-media-library');
  //inc(i);
  //args[i] := PAnsiChar('--ignore-config');
  //inc(i);
  args[i] := PAnsiChar('-I="dummy"');
  inc(i);
  //args[i] := PAnsiChar('--intf="globalhotkeys,none"');
  //inc(i);
  args[i] := Nil;
  //inc(i);

  //args[0] := pchar('--plugin-path=C:\Program Files (x86)\VideoLAN\VLC\plugins' );
  //args[1] := pchar('-I' );
  //args[2] := pchar('dummy' );
  //Args[4] := nil;

  VLCGetProcAddress('libvlc_new',@libvlc_new);
  FInstance:=libvlc_new (i,@Args,@Fexception.FException);
  FException.Check;
end;

Destructor TVLCInstance.Destroy;
begin
  Release;
  FException.Free;
  VLCUnloadLibrary;
  inherited Destroy;
end;

function TVLCInstance.get_log_verbosity: longword;
begin
  VLCGetProcAddress('libvlc_get_log_verbosity',@libvlc_get_log_verbosity);
  result:=libvlc_get_log_verbosity(FInstance);
end;

function TVLCInstance.media_new(const psz_mrl: UTF8String): TVLCMedia;
begin
  VLCGetProcAddress('libvlc_media_new',@libvlc_media_new);
  result:=TVLCMedia.Create( libvlc_media_new(FInstance,PansiChar(psz_mrl),@Fexception.FException));
  FException.Check;
end;

function TVLCInstance.media_new_as_node(psz_name: UTF8String): TVLCMedia;
begin
  VLCGetProcAddress('libvlc_media_new_as_node',@libvlc_media_new_as_node);
  result:=TVLCMedia.Create(libvlc_media_new_as_node(FInstance,PAnsiChar(psz_name),@Fexception.FException));
  FException.Check;
end;

function TVLCInstance.media_player_new: TVLCMediaPlayer;
begin
  VLCGetProcAddress('libvlc_media_player_new',@libvlc_media_player_new);
  result:=TVLCMediaPlayer.Create( libvlc_media_player_new(FInstance,@Fexception.FException));
  FException.Check;
end;

function TVLCInstance.audio_get_mute: longbool;
begin
  VLCGetProcAddress('libvlc_audio_get_mute',@libvlc_audio_get_mute);
  result:=libvlc_audio_get_mute(FInstance)
end;

function TVLCInstance.audio_get_volume: integer;
begin
  VLCGetProcAddress('libvlc_audio_get_volume',@libvlc_audio_get_volume);
  result:=libvlc_audio_get_volume(FInstance)
end;

function TVLCInstance.audio_output_device_count(
  psz_audio_output: UTF8String): integer;
begin
  VLCGetProcAddress('libvlc_audio_output_device_count',@libvlc_audio_output_device_count);
  result:=libvlc_audio_output_device_count(FInstance,PAnsiChar(psz_audio_output));
end;

function TVLCInstance.audio_output_device_id(psz_audio_output: UTF8String;
  i_device: Integer): UTF8String;
begin
  VLCGetProcAddress('libvlc_audio_output_device_id',@libvlc_audio_output_device_id);
  result:=UTF8String(libvlc_audio_output_device_id(Finstance,PAnsiChar(psz_audio_output),i_device));
end;

function TVLCInstance.audio_output_device_longname(
  psz_audio_output: UTF8String; i_device: Integer): UTF8String;
begin
  VLCGetProcAddress('libvlc_audio_output_device_longname',@libvlc_audio_output_device_longname);
  result:=UTF8String(libvlc_audio_output_device_longname(FInstance,PAnsiChar(psz_audio_output),i_device));
end;

procedure TVLCInstance.audio_output_device_set(psz_audio_output,
  psz_device_id: UTF8String);
begin
  VLCGetProcAddress('libvlc_audio_output_device_set',@libvlc_audio_output_device_set);
  libvlc_audio_output_device_set(FInstance,PAnsiChar(psz_audio_output),PAnsiChar(psz_device_id));
end;

function TVLCInstance.audio_output_get_device_type: integer;
begin
  VLCGetProcAddress('libvlc_audio_output_get_device_type',@libvlc_audio_output_get_device_type);
  result:=libvlc_audio_output_get_device_type(FInstance,@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.audio_output_list_get: Plibvlc_audio_output_t;
begin
  VLCGetProcAddress('libvlc_audio_output_list_get',@libvlc_audio_output_list_get);
  result:=libvlc_audio_output_list_get(FInstance,@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.audio_output_set(psz_name: UTF8String): integer;
begin
  VLCGetProcAddress('libvlc_audio_output_set',@libvlc_audio_output_set);
  result:=libvlc_audio_output_set(FINstance,PAnsiChar(psz_name));
end;

procedure TVLCInstance.audio_output_set_device_type(
  device_type: Integer);
begin
  VLCGetProcAddress('libvlc_audio_output_set_device_type',@libvlc_audio_output_set_device_type);
  libvlc_audio_output_set_device_type(FInstance,device_type,@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.audio_set_mute(status: longbool);
begin
  VLCGetProcAddress('libvlc_audio_set_mute',@libvlc_audio_set_mute);
  libvlc_audio_set_mute(FInstance,status);
end;

procedure TVLCInstance.audio_set_volume(i_volume: Integer);
begin
  VLCGetProcAddress('libvlc_audio_set_volume',@libvlc_audio_set_volume);
  libvlc_audio_set_volume(FInstance,i_volume,@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.audio_toggle_mute;
begin
  VLCGetProcAddress('libvlc_audio_toggle_mute',@libvlc_audio_toggle_mute);
  libvlc_audio_toggle_mute(FInstance);
end;

function TVLCInstance.audio_get_channel: integer;
begin
  VLCGetProcAddress('libvlc_audio_get_channel',@libvlc_audio_get_channel);
  result:=libvlc_audio_get_channel(FInstance,@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.audio_set_channel(channel: Integer);
begin
  VLCGetProcAddress('libvlc_audio_set_channel',@libvlc_audio_set_channel);
  libvlc_audio_set_channel(FInstance,channel,@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.media_list_new: TVLCMediaList;//Plibvlc_media_list_t;
begin
  VLCGetProcAddress('libvlc_media_list_new',@libvlc_media_list_new);
  result:=TVLCMediaList.Create( libvlc_media_list_new(FInstance,@Fexception.FException));
  FException.Check;
end;

function TVLCInstance.media_list_player_new: Plibvlc_media_list_player_t;
begin
  VLCGetProcAddress('libvlc_media_list_player_new',@libvlc_media_list_player_new);
  result:=libvlc_media_list_player_new(FInstance,@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.media_library_new: TVLCMediaLibrary;
begin
  VLCGetProcAddress('libvlc_media_library_new',@libvlc_media_library_new);
  result:=TVLCMediaLibrary.Create( libvlc_media_library_new(FInstance,@Fexception.FException));
  FException.Check;
end;

function TVLCInstance.media_discoverer_new_from_name(
  psz_name: UTF8String): Plibvlc_media_discoverer_t;
begin
  VLCGetProcAddress('libvlc_media_discoverer_new_from_name',@libvlc_media_discoverer_new_from_name);
  result:=libvlc_media_discoverer_new_from_name(FInstance,PAnsiChar(psz_name),@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.vlm_add_broadcast(psz_name, psz_input,
  psz_output: UTF8String; i_options: Integer; ppsz_options: array of UTF8String;
  b_enabled, b_loop: Integer);
Var
  P : PPAnsiChar;
begin
  P:=ArrayOfPAnsiChar(ppsz_options);
  VLCGetProcAddress('libvlc_vlm_add_broadcast',@libvlc_vlm_add_broadcast);
  libvlc_vlm_add_broadcast(FInstance,PAnsiChar(UTF8String(psz_name)), PAnsiChar(psz_input),
    PAnsiChar(psz_output),i_options, P,b_enabled, b_loop,@Fexception.FException);
  FException.Check;
  FreeMem(p);
end;

procedure TVLCInstance.vlm_add_input(psz_name, psz_input: UTF8String);
begin
  VLCGetProcAddress('libvlc_vlm_add_input',@libvlc_vlm_add_input);
  libvlc_vlm_add_input(FINstance,PAnsiChar(psz_name), PAnsiChar(psz_input),@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.vlm_add_vod(psz_name, psz_input: UTF8String;
  i_options: Integer; ppsz_options: array of UTF8String; b_enabled: Integer;
  psz_mux: UTF8String);
var
  P : PPAnsiChar;
begin
  P:=ArrayOfPAnsiChar(ppsz_options);
  VLCGetProcAddress('libvlc_vlm_add_vod',@libvlc_vlm_add_vod);
  libvlc_vlm_add_vod(FINstance,PAnsiChar(psz_name), PAnsiChar(psz_input),
    i_options,P ,b_enabled, PAnsiChar(psz_mux),@Fexception.FException);
  FException.Check;
  FreeMem(p);
end;

procedure TVLCInstance.vlm_change_media(psz_name, psz_input: UTF8String;
  psz_output: UTF8String; i_options: Integer; ppsz_options: PPAnsiChar; b_enabled,
  b_loop: Integer);
begin
  VLCGetProcAddress('libvlc_vlm_change_media',@libvlc_vlm_change_media);
  libvlc_vlm_change_media(FINstance,PAnsiChar(psz_name), PAnsiChar(psz_input),
    PAnsiChar(psz_output), i_options, ppsz_options, b_enabled,
    b_loop,@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.vlm_del_media(psz_name: UTF8String);
begin
  VLCGetProcAddress('libvlc_vlm_del_media',@libvlc_vlm_del_media);
  libvlc_vlm_del_media(FInstance,PAnsiChar(psz_name),@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.vlm_get_event_manager: TVLCEventManager;
begin
  VLCGetProcAddress('libvlc_vlm_get_event_manager',@libvlc_vlm_get_event_manager);
  result:=TVLCEventManager.Create(libvlc_vlm_get_event_manager(Finstance,@Fexception.FException));
  FException.Check;
end;

function TVLCInstance.vlm_get_media_instance_chapter(const psz_name: UTF8String;  i_instance: Integer): integer;
begin
  VLCGetProcAddress('libvlc_vlm_get_media_instance_chapter',@libvlc_vlm_get_media_instance_chapter);
  result:=libvlc_vlm_get_media_instance_chapter(FINstance,PAnsiChar(psz_name),i_instance,@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.vlm_get_media_instance_length(psz_name: UTF8String;  i_instance: Integer): integer;
begin
  VLCGetProcAddress('libvlc_vlm_get_media_instance_length',@libvlc_vlm_get_media_instance_length);
  result:=libvlc_vlm_get_media_instance_length(FINstance,PAnsiChar(psz_name),i_instance,@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.vlm_get_media_instance_position(psz_name: UTF8String;  i_instance: Integer): single;
begin
  VLCGetProcAddress('libvlc_vlm_get_media_instance_position',@libvlc_vlm_get_media_instance_position);
  result:=libvlc_vlm_get_media_instance_position(FINstance,PAnsiChar(psz_name),i_instance,@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.vlm_get_media_instance_rate(psz_name: UTF8String;  i_instance: Integer): integer;
begin
  VLCGetProcAddress('libvlc_vlm_get_media_instance_rate',@libvlc_vlm_get_media_instance_rate);
  result:=libvlc_vlm_get_media_instance_rate(FINstance,PAnsiChar(psz_name),i_instance,@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.vlm_get_media_instance_seekable(psz_name: UTF8String;  i_instance: Integer): integer;
begin
  VLCGetProcAddress('libvlc_vlm_get_media_instance_seekable',@libvlc_vlm_get_media_instance_seekable);
  result:=libvlc_vlm_get_media_instance_seekable(FINstance,PAnsiChar(psz_name),i_instance,@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.vlm_get_media_instance_time( psz_name: UTF8String;  i_instance: Integer): integer;
begin
  VLCGetProcAddress('libvlc_vlm_get_media_instance_time',@libvlc_vlm_get_media_instance_time);
  result:=libvlc_vlm_get_media_instance_time(FINstance,PAnsiChar(psz_name),i_instance,@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.vlm_get_media_instance_title( psz_name: UTF8String;  i_instance: Integer): integer;
begin
  VLCGetProcAddress('libvlc_vlm_get_media_instance_title',@libvlc_vlm_get_media_instance_title);
  result:=libvlc_vlm_get_media_instance_title(FINstance,PAnsiChar(psz_name),i_instance,@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.vlm_pause_media(psz_name: UTF8String);
begin
  VLCGetProcAddress('libvlc_vlm_pause_media',@libvlc_vlm_pause_media);
  libvlc_vlm_pause_media(FInstance,PAnsiChar(psz_name),@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.vlm_play_media(psz_name: UTF8String);
begin
  VLCGetProcAddress('libvlc_vlm_play_media',@libvlc_vlm_play_media);
  libvlc_vlm_play_media(FInstance,PAnsiChar(psz_name),@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.vlm_release;
begin
  VLCGetProcAddress('libvlc_vlm_release',@libvlc_vlm_release);
  libvlc_vlm_release(FInstance,@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.vlm_seek_media(psz_name: UTF8String;  f_percentage: Single);
begin
  VLCGetProcAddress('libvlc_vlm_seek_media',@libvlc_vlm_seek_media);
  libvlc_vlm_seek_media(FINstance,PAnsiChar(psz_name),f_percentage,@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.vlm_set_enabled(psz_name: UTF8String;
  b_enabled: Integer);
begin
  VLCGetProcAddress('libvlc_vlm_set_enabled',@libvlc_vlm_set_enabled);
  libvlc_vlm_set_enabled(FInstance,PAnsiChar(psz_name),b_enabled,@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.vlm_set_input(psz_name, psz_input: UTF8String);
begin
  VLCGetProcAddress('libvlc_vlm_set_input',@libvlc_vlm_set_input);
  libvlc_vlm_set_input(Finstance,PAnsiChar(psz_name), PAnsiChar(psz_input),@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.vlm_set_loop(psz_name: UTF8String;
  b_loop: Integer);
begin
  VLCGetProcAddress('libvlc_vlm_set_loop',@libvlc_vlm_set_loop);
  libvlc_vlm_set_loop(FINstance,PAnsiChar(psz_name),b_loop,@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.vlm_set_mux(psz_name, psz_mux: UTF8String);
begin
  VLCGetProcAddress('libvlc_vlm_set_mux',@libvlc_vlm_set_mux);
  libvlc_vlm_set_mux(FINstance,PAnsiChar(psz_name), PAnsiChar(psz_mux),@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.vlm_set_output(psz_name, psz_output: UTF8String);
begin
  VLCGetProcAddress('libvlc_vlm_set_output',@libvlc_vlm_set_output);
  libvlc_vlm_set_output(FINstance,PAnsiChar(psz_name), PAnsiChar(psz_output),@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.vlm_show_media(psz_name: UTF8String): UTF8String;
begin
  VLCGetProcAddress('libvlc_vlm_show_media',@libvlc_vlm_show_media);
  result:=UTF8String(libvlc_vlm_show_media(FInstance,PAnsiChar(psz_name),@Fexception.FException));
  FException.Check;
end;

procedure TVLCInstance.vlm_stop_media(psz_name: UTF8String);
begin
  VLCGetProcAddress('libvlc_vlm_stop_media',@libvlc_vlm_stop_media);
  libvlc_vlm_stop_media(FInstance,PAnsiChar(psz_name),@Fexception.FException);
  FException.Check;
end;

function TVLCInstance.log_open: TVlcLog;
begin
  VLCGetProcAddress('libvlc_log_open',@libvlc_log_open);
  result:=TVlcLog.Create( libvlc_log_open(FInstance,@Fexception.FException));
  FException.Check;
end;

procedure TVLCInstance.set_log_verbosity(level: Cardinal);
begin
  VLCGetProcAddress('libvlc_set_log_verbosity',@libvlc_set_log_verbosity);
  libvlc_set_log_verbosity(FInstance,level);
end;

function TVLCInstance.add_intf(name: UTF8String): integer;
begin
  VLCGetProcAddress('libvlc_add_intf',@libvlc_add_intf);
  if Name <> '' then
    result:=libvlc_add_intf(FInstance,PAnsiChar(Name),@Fexception.FException)
  else
    result:=libvlc_add_intf(FInstance,Nil,@Fexception.FException);
  FException.Check;
end;

procedure TVLCInstance.release;
begin
  if FINstance = Nil Then Exit;
  VLCGetProcAddress('libvlc_release',@libvlc_release);
  libvlc_release(FINstance);
  FINstance:=Nil;
end;

procedure TVLCInstance.retain;
begin
  VLCGetProcAddress('libvlc_retain',@libvlc_retain);
  libvlc_retain(FInstance)
end;

procedure TVLCInstance.wait;
begin
  VLCGetProcAddress('libvlc_wait',@libvlc_wait);
  libvlc_wait(FInstance);
end;

function TVLCInstance.new: TVLCMediaPlayer;
begin
  VLCGetProcAddress('libvlc_media_player_new',@libvlc_media_player_new);
  result:=TVLCMediaPlayer.Create(libvlc_media_player_new(FInstance,@Fexception.FException));
  FException.Check;
end;


{$ENDREGION}

{ TMediaPlayer }

{$REGION 'VLCMediaPlayer'}

constructor TVLCMediaPlayer.Create(aPlayer: Plibvlc_media_player_t);
begin
  inherited Create;
  if aPlayer = Nil then Abort;

  FException:=TVLCException.Create;
  FPlayer:=aPlayer;
end;

Destructor TVLCMediaPlayer.Destroy;
begin
  Release;
  FException.Free;
  inherited Destroy;
end;

procedure TVLCMediaPlayer.release;
begin
  VLCGetProcAddress('libvlc_media_player_release',@libvlc_media_player_release);
  libvlc_media_player_release(FPlayer);
end;

function TVLCMediaPlayer.can_pause: longbool;
begin
  VLCGetProcAddress('libvlc_media_player_can_pause',@libvlc_media_player_can_pause);
  Result:=libvlc_media_player_can_pause(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.event_manager: TVLCEventManager;
begin
  VLCGetProcAddress('libvlc_media_player_event_manager',@libvlc_media_player_event_manager);
  Result:=TVLCEventManager.Create( libvlc_media_player_event_manager(FPlayer,@Fexception.FException));
  FException.Check;
end;

function TVLCMediaPlayer.get_agl: uint32;
begin
  VLCGetProcAddress('libvlc_media_player_get_agl',@libvlc_media_player_get_agl);
  Result:=libvlc_media_player_get_agl(FPlayer);
end;

function TVLCMediaPlayer.get_chapter: integer;
begin
  VLCGetProcAddress('libvlc_media_player_get_chapter',@libvlc_media_player_get_chapter);
  Result:=libvlc_media_player_get_chapter(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.get_chapter_count: integer;
begin
  VLCGetProcAddress('libvlc_media_player_get_chapter_count',@libvlc_media_player_get_chapter_count);
  Result:=libvlc_media_player_get_chapter_count(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.get_chapter_count_for_title(
  i_title: Integer): integer;
begin
  VLCGetProcAddress('libvlc_media_player_get_chapter_count_for_title',@libvlc_media_player_get_chapter_count_for_title);
  result:=libvlc_media_player_get_chapter_count_for_title(FPlayer,i_title,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.get_fps: single;
begin
  VLCGetProcAddress('libvlc_media_player_get_fps',@libvlc_media_player_get_fps);
  Result:=libvlc_media_player_get_fps(FPlayer,@Fexception.FException);
  FException.Check;
end;

{$IFDEF WIN32}
function TVLCMediaPlayer.get_hwnd: THandle;
begin
  VLCGetProcAddress('libvlc_media_player_get_hwnd',@libvlc_media_player_get_hwnd);
  Result:=libvlc_media_player_get_hwnd(FPlayer);
end;
{$ENDIF}

function TVLCMediaPlayer.get_length: libvlc_time_t;
begin
  VLCGetProcAddress('libvlc_media_player_get_length',@libvlc_media_player_get_length);
  Result:=libvlc_media_player_get_length(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.get_media: TVLCMedia;
begin
  VLCGetProcAddress('libvlc_media_player_get_media',@libvlc_media_player_get_media);
  Result:=TVLCMedia.Create(libvlc_media_player_get_media(FPlayer,@Fexception.FException));
  FException.Check;
end;

function TVLCMediaPlayer.get_nsobject: Pointer;
begin
  VLCGetProcAddress('libvlc_media_player_get_nsobject',@libvlc_media_player_get_nsobject);
  Result:=libvlc_media_player_get_nsobject(FPlayer);
end;

function TVLCMediaPlayer.get_position: Single;
begin
  VLCGetProcAddress('libvlc_media_player_get_position',@libvlc_media_player_get_position);
  result:=libvlc_media_player_get_position(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.get_rate: single;
begin
  VLCGetProcAddress('libvlc_media_player_get_rate',@libvlc_media_player_get_rate);
  Result:=libvlc_media_player_get_rate(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.get_state: libvlc_state_t;
begin
  VLCGetProcAddress('libvlc_media_player_get_state',@libvlc_media_player_get_state);
  Result:=libvlc_media_player_get_state(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.get_time: libvlc_time_t;
begin
  VLCGetProcAddress('libvlc_media_player_get_time',@libvlc_media_player_get_time);
  Result:=libvlc_media_player_get_time(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.get_title: integer;
begin
  VLCGetProcAddress('libvlc_media_player_get_title',@libvlc_media_player_get_title);
  result:=libvlc_media_player_get_title(FPlayer, @Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.get_title_count: integer;
begin
  VLCGetProcAddress('libvlc_media_player_get_title_count',@libvlc_media_player_get_title_count);
  Result:=libvlc_media_player_get_title_count(FPlayer,@Fexception.FException);
  FException.Check;
end;

{$IFDEF LINUX}
function TMediaPlayer.get_xwindow: uint32;
begin
  VLCGetProcAddress('libvlc_media_player_get_xwindow',@libvlc_media_player_get_xwindow);
  result:=libvlc_media_player_get_xwindow(FPlayer);
end;
{$ENDIF}

function TVLCMediaPlayer.has_vout: longbool;
begin
  VLCGetProcAddress('libvlc_media_player_has_vout',@libvlc_media_player_has_vout);
  result:=libvlc_media_player_has_vout(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.is_playing: longbool;
begin
  VLCGetProcAddress('libvlc_media_player_is_playing',@libvlc_media_player_is_playing);
  Result:=libvlc_media_player_is_playing(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.is_seekable: longbool;
begin
  VLCGetProcAddress('libvlc_media_player_is_seekable',@libvlc_media_player_is_seekable);
  result:=libvlc_media_player_is_seekable(FPlayer,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.next_chapter;
begin
  VLCGetProcAddress('libvlc_media_player_next_chapter',@libvlc_media_player_next_chapter);
  libvlc_media_player_next_chapter(Fplayer,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.next_frame;
begin
  VLCGetProcAddress('libvlc_media_player_next_frame',@libvlc_media_player_next_frame);
  libvlc_media_player_next_frame(FPlayer,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.pause;
begin
  VLCGetProcAddress('libvlc_media_player_pause',@libvlc_media_player_pause);
  libvlc_media_player_pause(FPlayer,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.play;
begin
  VLCGetProcAddress('libvlc_media_player_play',@libvlc_media_player_play);
  libvlc_media_player_play(FPlayer,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.previous_chapter;
begin
  VLCGetProcAddress('libvlc_media_player_previous_chapter',@libvlc_media_player_previous_chapter);
  libvlc_media_player_previous_chapter(FPlayer,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.retain;
begin
  VLCGetProcAddress('libvlc_media_player_retain',@libvlc_media_player_retain);
  libvlc_media_player_retain(Fplayer);
end;

procedure TVLCMediaPlayer.set_agl(drawable: uint32);
begin
  VLCGetProcAddress('libvlc_media_player_set_agl',@libvlc_media_player_set_agl);
  libvlc_media_player_set_agl(Fplayer,drawable,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.set_chapter(i_chapter: Integer);
begin
  VLCGetProcAddress('libvlc_media_player_set_chapter',@libvlc_media_player_set_chapter);
  libvlc_media_player_set_chapter(Fplayer,i_chapter,@Fexception.FException);
  FException.Check;
end;

{$IFDEF WIN32}
procedure TVLCMediaPlayer.set_hwnd(drawable: THandle);
begin
  VLCGetProcAddress('libvlc_media_player_set_hwnd',@libvlc_media_player_set_hwnd);
  libvlc_media_player_set_hwnd(FPlayer,drawable,@Fexception.FException);
  FException.Check;
end;
{$ENDIF}

procedure TVLCMediaPlayer.set_media(media: TVLCMedia);
begin
  VLCGetProcAddress('libvlc_media_player_set_media',@libvlc_media_player_set_media);
  libvlc_media_player_set_media(FPlayer,media.FMedia,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.set_nsobject(drawable: Pointer);
begin
  VLCGetProcAddress('libvlc_media_player_set_nsobject',@libvlc_media_player_set_nsobject);
  libvlc_media_player_set_nsobject(FPlayer,drawable,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.set_position(f_pos: Single);
begin
  VLCGetProcAddress('libvlc_media_player_set_position',@libvlc_media_player_set_position);
  libvlc_media_player_set_position(Fplayer, f_pos,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.set_rate(rate: Single);
begin
  VLCGetProcAddress('libvlc_media_player_set_rate',@libvlc_media_player_set_rate);
  libvlc_media_player_set_rate(FPlayer,rate,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.set_time(time: libvlc_time_t);
begin
  VLCGetProcAddress('libvlc_media_player_set_time',@libvlc_media_player_set_time);
  libvlc_media_player_set_time(FPlayer,time,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.set_title(i_title: Integer);
begin
  VLCGetProcAddress('libvlc_media_player_set_title',@libvlc_media_player_set_title);
  libvlc_media_player_set_title(FPlayer,i_title,@Fexception.FException);
  FException.Check;
end;

{$IFDEF LINUX}
procedure TMediaPlayer.set_xwindow(drawable: uint32);
begin
  VLCGetProcAddress('libvlc_media_player_set_xwindow',@libvlc_media_player_set_xwindow);
  libvlc_media_player_set_xwindow(FPlayer,drawable,@Fexception.FException);
  FException.Check;
end;
{$ENDIF}

procedure TVLCMediaPlayer.stop;
begin
  VLCGetProcAddress('libvlc_media_player_stop',@libvlc_media_player_stop);
  libvlc_media_player_stop(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.get_fullscreen: Longbool;
begin
  VLCGetProcAddress('libvlc_get_fullscreen',@libvlc_get_fullscreen);
  result:=Longbool(libvlc_get_fullscreen(FPlayer,@Fexception.FException));
  FException.Check;
end;

function TVLCMediaPlayer.will_play: longbool;
begin
  VLCGetProcAddress('libvlc_media_player_will_play',@libvlc_media_player_will_play);
  result:=libvlc_media_player_will_play(FPlayer,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.set_fullscreen(b_fullscreen: LongBool);
begin
  VLCGetProcAddress('libvlc_set_fullscreen',@libvlc_set_fullscreen);
  libvlc_set_fullscreen(FPlayer,b_fullscreen, @Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.toggle_fullscreen;
begin
  VLCGetProcAddress('libvlc_toggle_fullscreen',@libvlc_toggle_fullscreen);
  libvlc_toggle_fullscreen(FPlayer,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.toggle_teletext;
begin
  VLCGetProcAddress('libvlc_toggle_teletext',@libvlc_toggle_teletext);
  libvlc_toggle_teletext(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.Video_get_aspect_ratio: UTF8String;
begin
  VLCGetProcAddress('libvlc_video_get_aspect_ratio',@libvlc_video_get_aspect_ratio);
  result:=UTF8String(libvlc_video_get_aspect_ratio(FPlayer,@Fexception.FException));
  FException.Check;
end;

function TVLCMediaPlayer.video_get_chapter_description(i_title: Integer): Plibvlc_track_description_t;
begin
  VLCGetProcAddress('libvlc_video_get_chapter_description',@libvlc_video_get_chapter_description);
  result:=libvlc_video_get_chapter_description(FPlayer,i_title,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.Video_get_crop_geometry: UTF8String;
begin
  VLCGetProcAddress('libvlc_video_get_crop_geometry',@libvlc_video_get_crop_geometry);
  result:=UTF8String(libvlc_video_get_crop_geometry(FPlayer,@Fexception.FException));
  FException.Check;
end;

function TVLCMediaPlayer.Video_get_height: integer;
begin
  VLCGetProcAddress('libvlc_video_get_height',@libvlc_video_get_height);
  result:=libvlc_video_get_height(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.Video_get_marquee_option_as_int( option :
  libvlc_video_marquee_int_option_t): integer;
begin
  VLCGetProcAddress('libvlc_video_get_marquee_option_as_int',@libvlc_video_get_marquee_option_as_int);
  result:=libvlc_video_get_marquee_option_as_int(FPlayer,option,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.Video_get_marquee_option_as_string(option :
  libvlc_video_marquee_string_option_t): UTF8String;
begin
  VLCGetProcAddress('libvlc_video_get_marquee_option_as_string',@libvlc_video_get_marquee_option_as_string);
  result:=UTF8String(libvlc_video_get_marquee_option_as_string(FPlayer,option,@Fexception.FException));
  FException.Check;
end;

function TVLCMediaPlayer.Video_get_scale: single;
begin
  VLCGetProcAddress('libvlc_video_get_scale',@libvlc_video_get_scale);
  result:=libvlc_video_get_scale(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.video_get_spu: integer;
begin
  VLCGetProcAddress('libvlc_video_get_spu',@libvlc_video_get_spu);
  result:=libvlc_video_get_spu(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.video_get_spu_count: integer;
begin
  VLCGetProcAddress('libvlc_video_get_spu_count',@libvlc_video_get_spu_count);
  result:=libvlc_video_get_spu_count(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.video_get_spu_description: Plibvlc_track_description_t;
begin
  VLCGetProcAddress('libvlc_video_get_spu_description',@libvlc_video_get_spu_description);
  result:=libvlc_video_get_spu_description(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.video_get_teletext: integer;
begin
  VLCGetProcAddress('libvlc_video_get_teletext',@libvlc_video_get_teletext);
  result:=libvlc_video_get_teletext(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.video_get_title_description: Plibvlc_track_description_t;
begin
  VLCGetProcAddress('libvlc_video_get_title_description',@libvlc_video_get_title_description);
  Result:=libvlc_video_get_title_description(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.video_get_track: integer;
begin
  VLCGetProcAddress('libvlc_video_get_track',@libvlc_video_get_track);
  result:=libvlc_video_get_track(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.video_get_track_count: integer;
begin
  VLCGetProcAddress('libvlc_video_get_track_count',@libvlc_video_get_track_count);
  result:=libvlc_video_get_track_count(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.video_get_track_description: Plibvlc_track_description_t;
begin
  VLCGetProcAddress('libvlc_video_get_track_description',@libvlc_video_get_track_description);
  result:=libvlc_video_get_track_description(FPlayer,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.Video_get_width: integer;
begin
  VLCGetProcAddress('libvlc_video_get_width',@libvlc_video_get_width);
  result:=libvlc_video_get_width(FPlayer,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.Video_set_aspect_ratio(psz_aspect: UTF8String);
begin
  VLCGetProcAddress('libvlc_video_set_aspect_ratio',@libvlc_video_set_aspect_ratio);
  libvlc_video_set_aspect_ratio(FPlayer,PansiChar(psz_aspect),@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.Video_set_crop_geometry(psz_geometry: UTF8String);
begin
  VLCGetProcAddress('libvlc_video_set_crop_geometry',@libvlc_video_set_crop_geometry);
  libvlc_video_set_crop_geometry(FPlayer,PAnsiChar(psz_geometry),@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.video_set_deinterlace(b_enable: Integer;
  psz_mode: UTF8String);
begin
  VLCGetProcAddress('libvlc_video_set_deinterlace',@libvlc_video_set_deinterlace);
  libvlc_video_set_deinterlace(FPlayer,b_enable,PAnsiChar(psz_mode),@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.video_set_key_input(_on: Cardinal);
begin
  VLCGetProcAddress('libvlc_video_set_key_input',@libvlc_video_set_key_input);
  libvlc_video_set_key_input(FPlayer,_on)
end;

procedure TVLCMediaPlayer.Video_set_marquee_option_as_int( option : libvlc_video_marquee_int_option_t;
                                                  i_val: Integer);
begin
  VLCGetProcAddress('libvlc_video_set_marquee_option_as_int',@libvlc_video_set_marquee_option_as_int);
  libvlc_video_set_marquee_option_as_int(FPlayer,option, i_val,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.Video_set_marquee_option_as_string(
  option: libvlc_video_marquee_string_option_t; psz_text: UTF8String);
begin
  VLCGetProcAddress('libvlc_video_set_marquee_option_as_string',@libvlc_video_set_marquee_option_as_string);
  libvlc_video_set_marquee_option_as_string(FPlayer,option,PAnsiChar(psz_text),@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.Video_set_mouse_input(_on: Cardinal);
begin
  VLCGetProcAddress('libvlc_video_set_mouse_input',@libvlc_video_set_mouse_input);
  libvlc_video_set_mouse_input(FPlayer,_on)
end;

procedure TVLCMediaPlayer.Video_set_scale(i_factor: Single);
begin
  VLCGetProcAddress('libvlc_video_set_scale',@libvlc_video_set_scale);
  libvlc_video_set_scale(FPlayer,i_factor,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.Video_set_spu(i_spu: Integer);
begin
  VLCGetProcAddress('libvlc_video_set_spu',@libvlc_video_set_spu);
  libvlc_video_set_spu(FPlayer,i_spu,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaPlayer.video_set_subtitle_file(psz_subtitle: UTF8String): integer;
begin
  VLCGetProcAddress('libvlc_video_set_subtitle_file',@libvlc_video_set_subtitle_file);
  result:=libvlc_video_set_subtitle_file(FPlayer,PAnsiChar(psz_subtitle),@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.video_set_teletext(i_page: Integer);
begin
  VLCGetProcAddress('libvlc_video_set_teletext',@libvlc_video_set_teletext);
  libvlc_video_set_teletext(FPlayer,i_page,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.video_set_track(i_track: Integer);
begin
  VLCGetProcAddress('libvlc_video_set_track',@libvlc_video_set_track);
  libvlc_video_set_track(FPlayer,i_track,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaPlayer.video_take_snapshot(psz_filepath: UTF8String;
  i_width, i_height: Cardinal);
begin
  VLCGetProcAddress('libvlc_video_take_snapshot',@libvlc_video_take_snapshot);
  libvlc_video_take_snapshot(FPlayer,PAnsiChar(psz_filepath),i_width, i_height,@Fexception.FException);
  FException.Check;
end;

{$ENDREGION}

{ TMEdia }

{$REGION 'VLCMedia'}

constructor TVLCMedia.Create(aMedia: Plibvlc_media_t);
begin
  Inherited Create;
  FException:=TVLCException.Create;
  FMedia:=aMedia;
end;

Destructor TVLCMedia.Destroy;
begin
  release;
  FException.Free;
  inherited Destroy;
end;

function TVLCMedia.player_new_from_media: TVLCMediaPlayer;
begin
  VLCGetProcAddress('libvlc_media_player_new_from_media',@libvlc_media_player_new_from_media);
  Result:=TVLCMediaPlayer.Create( libvlc_media_player_new_from_media(FMedia,@Fexception.FException));
  FException.Check;
end;


procedure TVLCMedia.add_option(ppsz_options: UTF8String);
begin
  VLCGetProcAddress('libvlc_media_add_option',@libvlc_media_add_option);
  libvlc_media_add_option(Fmedia,PAnsiChar(ppsz_options));
end;

procedure TVLCMedia.add_option_untrusted(ppsz_options: PAnsiChar);
begin
  VLCGetProcAddress('libvlc_media_add_option',@libvlc_media_add_option);
  libvlc_media_add_option_untrusted(FMedia,ppsz_options,@Fexception.FException);
end;

procedure TVLCMedia.add_option_flag(ppsz_options: UTF8String;
  i_flags: libvlc_media_option_t);
begin
  VLCGetProcAddress('libvlc_media_add_option_flag',@libvlc_media_add_option_flag);
  libvlc_media_add_option_flag(Fmedia,PAnsiChar(ppsz_options),i_flags)
end;

function TVLCMedia.duplicate: TVLCMedia;
begin
  VLCGetProcAddress('libvlc_media_duplicate',@libvlc_media_duplicate);
  result:=TVLCMedia.Create( libvlc_media_duplicate(Fmedia));
end;

function TVLCMedia.event_manager: TVLCEventManager;
begin
  VLCGetProcAddress('libvlc_media_event_manager',@libvlc_media_event_manager);
  result:=TVLCEventManager.Create( libvlc_media_event_manager(Fmedia));
end;

function TVLCMedia.get_duration: libvlc_time_t;
begin
  VLCGetProcAddress('libvlc_media_get_duration',@libvlc_media_get_duration);
  result:=libvlc_media_get_duration(Fmedia,@Fexception.FException);
  FException.Check;
end;

function TVLCMedia.get_meta(e_meta: libvlc_meta_t): UTF8String;
begin
  VLCGetProcAddress('libvlc_media_get_meta',@libvlc_media_get_meta);
  result:=UTF8String(libvlc_media_get_meta(Fmedia,e_meta));
end;

function TVLCMedia.get_mrl: UTF8String;
begin
  VLCGetProcAddress('libvlc_media_get_mrl',@libvlc_media_get_mrl);
  result:=UTF8String(AnsiCHar(libvlc_media_get_mrl(Fmedia)));
end;

function TVLCMedia.get_state: libvlc_state_t;
begin
  VLCGetProcAddress('libvlc_media_get_state',@libvlc_media_get_state);
  Result:=libvlc_media_get_state(Fmedia)
end;

function TVLCMedia.get_user_data: Pointer;
begin
  VLCGetProcAddress('libvlc_media_get_user_data',@libvlc_media_get_user_data);
  Result:=libvlc_media_get_user_data(Fmedia)
end;

function TVLCMedia.is_preparsed: longbool;
begin
  VLCGetProcAddress('libvlc_media_is_preparsed',@libvlc_media_is_preparsed);
  Result:=Longbool(libvlc_media_is_preparsed(Fmedia));
end;


procedure TVLCMedia.release;
begin
  VLCGetProcAddress('libvlc_media_release',@libvlc_media_release);
  libvlc_media_release(Fmedia)
end;

procedure TVLCMedia.retain;
begin
  VLCGetProcAddress('libvlc_media_retain',@libvlc_media_retain);
  libvlc_media_retain(Fmedia)
end;

procedure TVLCMedia.set_user_data(p_new_user_data: Pointer);
begin
  VLCGetProcAddress('libvlc_media_set_user_data',@libvlc_media_set_user_data);
  libvlc_media_set_user_data(Fmedia,p_new_user_data)
end;

function TVLCMedia.subitems: TVLCMediaList; // Plibvlc_media_list_t;
begin
  VLCGetProcAddress('libvlc_media_subitems',@libvlc_media_subitems);
  Result:=TVLCMediaList.Create( libvlc_media_subitems(Fmedia));
end;

{$ENDREGION}

{ TMediaList }

{$REGION 'MediaList'}

{$REGION 'VLCMediaList'}

constructor TVLCMediaList.Create(aML: Plibvlc_media_list_t);
begin
  INherited Create;
  FException:=TVLCException.Create;
  FMediaList:=aML;
end;

destructor TVLCMediaList.Destroy;
begin
  release;
  FException.Free;
  inherited;
end;

procedure TVLCMediaList.add_file_content(psz_uri: UTF8String);
begin
  VLCGetProcAddress('libvlc_media_list_add_file_content',@libvlc_media_list_add_file_content);
  libvlc_media_list_add_file_content(FMediaList,PAnsiChar(psz_uri),@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaList.add_media(media: TVLCMedia);
begin
  VLCGetProcAddress('libvlc_media_list_add_media',@libvlc_media_list_add_media);
  libvlc_media_list_add_media(FMediaList,Media.FMedia,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaList.Getcount: integer;
begin
  VLCGetProcAddress('libvlc_media_list_count',@libvlc_media_list_count);
  result:=libvlc_media_list_count(FMedialist,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaList.event_manager: TVLCEventManager;
begin
  VLCGetProcAddress('libvlc_media_list_event_manager',@libvlc_media_list_event_manager);
  result:=TVLCEventManager.Create( libvlc_media_list_event_manager(FMedialist,@Fexception.FException));
  FException.Check;
end;

function TVLCMediaList.flat_view: Plibvlc_media_list_view_t;
begin
  VLCGetProcAddress('libvlc_media_list_flat_view',@libvlc_media_list_flat_view);
  result:=libvlc_media_list_flat_view(FMedialist,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaList.hierarchical_node_view: Plibvlc_media_list_view_t;
begin
  VLCGetProcAddress('libvlc_media_list_hierarchical_node_view',@libvlc_media_list_hierarchical_node_view);
  result:=libvlc_media_list_hierarchical_node_view(FMedialist,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaList.hierarchical_view: Plibvlc_media_list_view_t;
begin
  VLCGetProcAddress('libvlc_media_list_hierarchical_view',@libvlc_media_list_hierarchical_view);
  result:=libvlc_media_list_hierarchical_view(FMedialist,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaList.index_of_item(media: TVLCMedia): integer;
begin
  VLCGetProcAddress('libvlc_media_list_index_of_item',@libvlc_media_list_index_of_item);
  Result:=libvlc_media_list_index_of_item(FMedialist,Media.FMedia,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaList.insert_media(media: TVLCMedia;
  i_pos: Integer);
begin
  VLCGetProcAddress('libvlc_media_list_insert_media',@libvlc_media_list_insert_media);
  libvlc_media_list_insert_media(FMedialist,Media.FMedia,i_pos,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaList.is_readonly: longbool;
begin
  VLCGetProcAddress('libvlc_media_list_is_readonly',@libvlc_media_list_is_readonly);
  result:=libvlc_media_list_is_readonly(FMediaList);
end;

function TVLCMediaList.item_at_index( i_pos: Integer): TVLCMedia;
begin
  VLCGetProcAddress('libvlc_media_list_item_at_index',@libvlc_media_list_item_at_index);
  Result:=TVLCMedia.Create(libvlc_media_list_item_at_index(FMedialist,i_pos,@Fexception.FException));
  FException.Check;
end;

procedure TVLCMediaList.lock;
begin
  VLCGetProcAddress('libvlc_media_list_lock',@libvlc_media_list_lock);
  libvlc_media_list_lock(FMedialist);
end;

function TVLCMediaList.media: TVLCMedia;
begin
  VLCGetProcAddress('libvlc_media_list_media',@libvlc_media_list_media);
  result:=TVLCMedia.Create( libvlc_media_list_media(FMedialist,@Fexception.FException));
  FException.Check;
end;

procedure TVLCMediaList.release;
begin
  VLCGetProcAddress('libvlc_media_list_release',@libvlc_media_list_release);
  libvlc_media_list_release(FMedialist);
end;

procedure TVLCMediaList.remove_index(i_pos: Integer);
begin
  VLCGetProcAddress('libvlc_media_list_remove_index',@libvlc_media_list_remove_index);
  libvlc_media_list_remove_index(FMedialist,i_pos,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaList.retain;
begin
  VLCGetProcAddress('libvlc_media_list_retain',@libvlc_media_list_retain);
  libvlc_media_list_retain(FMedialist);
end;

procedure TVLCMediaList.set_media(media: TVLCMedia);
begin
  VLCGetProcAddress('libvlc_media_list_set_media',@libvlc_media_list_set_media);
  libvlc_media_list_set_media(FMedialist,Media.FMedia,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaList.unlock;
begin
  VLCGetProcAddress('libvlc_media_list_unlock',@libvlc_media_list_unlock);
  libvlc_media_list_unlock(FMedialist);
end;

{$ENDREGION}

{$ENDREGION}

{ TEventManager }

{$REGION 'VLCEventManager'}

constructor TVLCEventManager.Create(aEvent: Plibvlc_event_manager_t);
begin
  Inherited Create;
  FEvent:=aEvent;
  FException:=TVLCException.Create;
end;


procedure TVLCEventManager.attach(i_event_type: libvlc_event_type_t;
  f_callback: libvlc_callback_t; user_data: Pointer);
begin
  VLCGetProcAddress('libvlc_event_attach',@libvlc_event_attach);
  libvlc_event_attach(FEvent,i_event_type,f_callback,user_data,@Fexception.FException);
  FException.Check;
end;

procedure TVLCEventManager.detach(i_event_type: libvlc_event_type_t;
  f_callback: libvlc_callback_t; p_user_data: Pointer);
begin
  VLCGetProcAddress('libvlc_event_detach',@libvlc_event_detach);
  libvlc_event_detach(FEvent,i_event_type,f_callback,p_user_data,@Fexception.FException);
  FException.Check;
end;

{$ENDREGION}


{ TException }

{$REGION 'VLCException'}

constructor TVLCException.Create;
begin
  Inherited Create;
  Init;
end;

destructor TVLCException.Destroy;
begin
  Clear;
  inherited;
end;

procedure TVLCException.Check;
Var
  Msg : UTF8String;
begin
  if raised then
  begin
    Msg:=UTF8String(FException.psz_message);
    clear; // clear exception
    Raise Exception.CreateFmt('error: %s', [Msg]);
  end;
end;

procedure TVLCException.clear;
begin
  VLCGetProcAddress('libvlc_exception_clear',@libvlc_exception_clear);
  libvlc_exception_clear(@FException);
end;

procedure TVLCException.init;
begin
  VLCGetProcAddress('libvlc_exception_init',@libvlc_exception_init);
  libvlc_exception_init(@FException);
end;

function TVLCException.get_message: UTF8String;
begin
  VLCGetProcAddress('libvlc_exception_get_message',@libvlc_exception_get_message);
  Result:=UTF8String(libvlc_exception_get_message(@FException));
end;

procedure TVLCException.RaiseException;
begin
  VLCGetProcAddress('libvlc_exception_raise',@libvlc_exception_raise);
  libvlc_exception_raise(@FException);
end;

function TVLCException.raised: longbool;
begin
  VLCGetProcAddress('libvlc_exception_raised',@libvlc_exception_raised);
  Result:=Longbool(libvlc_exception_raised(@FException));
end;

{$ENDREGION}


{ TMediaLibrary }

{$REGION 'VLCMediaLibrary'}

constructor TVLCMediaLibrary.Create(aLibrary: Plibvlc_media_library_t);
begin
  Inherited Create;
  FException:=TVLCException.Create;
  FLibrary:=aLibrary;
end;

destructor TVLCMediaLibrary.Destroy;
begin
  Release;
  FException.Free;
  inherited;
end;

procedure TVLCMediaLibrary.load;
begin
  VLCGetProcAddress('libvlc_media_library_load',@libvlc_media_library_load);
  libvlc_media_library_load(FLibrary,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaLibrary.media_list: TVLCMediaList;
begin
  VLCGetProcAddress('libvlc_media_library_media_list',@libvlc_media_library_media_list);
  Result:=TVLCMediaList.Create( libvlc_media_library_media_list(FLibrary,@Fexception.FException));
  FException.Check;
end;

procedure TVLCMediaLibrary.release;
begin
  VLCGetProcAddress('libvlc_media_library_release',@libvlc_media_library_release);
  libvlc_media_library_release(FLibrary);
end;

procedure TVLCMediaLibrary.retain;
begin
  VLCGetProcAddress('libvlc_media_library_retain',@libvlc_media_library_retain);
  libvlc_media_library_retain(FLibrary);
end;

procedure TVLCMediaLibrary.save;
begin
  VLCGetProcAddress('libvlc_media_library_save',@libvlc_media_library_save);
  libvlc_media_library_save(FLibrary,@Fexception.FException);
  FException.Check;
end;

{$ENDREGION}

{ TMediaControl }

{$REGION 'VLCMediaControl'}

procedure TVLCMediaControl.display_text(_message: UTF8String; _begin,
  _end: Pmediacontrol_Position);
begin
  VLCGetProcAddress('mediacontrol_display_text',@mediacontrol_display_text);
  mediacontrol_display_text(FMediaControl,PAnsiChar(_message),_begin,_end,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaControl.exit;
begin
  VLCGetProcAddress('mediacontrol_exit',@mediacontrol_exit);
  mediacontrol_exit(FMediaControl);
end;

function TVLCMediaControl.get_fullscreen: longbool;
begin
  VLCGetProcAddress('mediacontrol_get_fullscreen',@mediacontrol_get_fullscreen);
  result:=longbool(mediacontrol_get_fullscreen(FMediaControl,@Fexception.FException));
  FException.Check;
end;

function TVLCMediaControl.get_libvlc_instance: Plibvlc_instance_t;
begin
  VLCGetProcAddress('mediacontrol_get_libvlc_instance',@mediacontrol_get_libvlc_instance);
  result:=mediacontrol_get_libvlc_instance(FMediaControl);
end;

function TVLCMediaControl.get_media_player: Plibvlc_media_player_t;
begin
  VLCGetProcAddress('mediacontrol_get_media_player',@mediacontrol_get_media_player);
  result:=mediacontrol_get_media_player(FMediaControl);
end;

function TVLCMediaControl.get_media_position(
  an_origin: mediacontrol_PositionOrigin;
  a_key: mediacontrol_PositionKey): Pmediacontrol_Position;
begin
  VLCGetProcAddress('mediacontrol_get_media_position',@mediacontrol_get_media_position);
  result:=mediacontrol_get_media_position(FMediaControl,an_origin,a_key,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaControl.get_mrl: UTF8String;
begin
  VLCGetProcAddress('mediacontrol_get_mrl',@mediacontrol_get_mrl);
  result:=UTF8String(mediacontrol_get_mrl(FMediaControl,@Fexception.FException));
  FException.Check;
end;

function TVLCMediaControl.get_rate: integer;
begin
  VLCGetProcAddress('mediacontrol_get_rate',@mediacontrol_get_rate);
  result:=mediacontrol_get_rate(FMediaControl,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaControl.get_stream_information(
  a_key: mediacontrol_PositionKey): Pmediacontrol_StreamInformation;
begin
  VLCGetProcAddress('mediacontrol_get_stream_information',@mediacontrol_get_stream_information);
  result:=mediacontrol_get_stream_information(FMediaControl,a_key,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaControl.new_from_instance(VLC : TVLCInstance):TVLCMediaControl;
begin
  VLCGetProcAddress('mediacontrol_new_from_instance',@mediacontrol_new_from_instance);
  Result:=TVLCMediaControl.Create;
  result.FMediaControl:=mediacontrol_new_from_instance(VLC.FInstance,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaControl.pause;
begin
  VLCGetProcAddress('mediacontrol_pause',@mediacontrol_pause);
  mediacontrol_pause(FMediaControl,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaControl.resume;
begin
  VLCGetProcAddress('mediacontrol_resume',@mediacontrol_resume);
  mediacontrol_resume(FMediaControl,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaControl.set_fullscreen(b_fullscreen: longbool);
begin
  VLCGetProcAddress('mediacontrol_set_fullscreen',@mediacontrol_set_fullscreen);
  mediacontrol_set_fullscreen(FMediaControl,b_fullscreen,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaControl.set_media_position(
  a_position: Pmediacontrol_Position);
begin
  VLCGetProcAddress('mediacontrol_set_media_position',@mediacontrol_set_media_position);
  mediacontrol_set_media_position(FMediaControl,a_position,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaControl.set_mrl(psz_file: UTF8String);
begin
  VLCGetProcAddress('mediacontrol_set_mrl',@mediacontrol_set_mrl);
  mediacontrol_set_mrl(FMediaControl,PAnsiChar(psz_file),@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaControl.set_rate(rate: Integer);
begin
  VLCGetProcAddress('mediacontrol_set_rate',@mediacontrol_set_rate);
  mediacontrol_set_rate(FMediaControl,rate,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaControl.set_visual(visual_id: THANDLE): integer;
begin
  VLCGetProcAddress('mediacontrol_set_visual',@mediacontrol_set_visual);
  result:=mediacontrol_set_visual(FMediaControl,visual_id,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaControl.snapshot(
  a_position: Pmediacontrol_Position): Pmediacontrol_RGBPicture;
begin
  VLCGetProcAddress('mediacontrol_snapshot',@mediacontrol_snapshot);
  result:=mediacontrol_snapshot(FMediaControl,a_position,@Fexception.FException);
  FException.Check;
end;

function TVLCMediaControl.sound_get_volume: Word;
begin
  VLCGetProcAddress('mediacontrol_sound_get_volume',@mediacontrol_sound_get_volume);
  Result:=mediacontrol_sound_get_volume(FMediaControl,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaControl.sound_set_volume(volume: Word);
begin
  VLCGetProcAddress('mediacontrol_sound_set_volume',@mediacontrol_sound_set_volume);
  mediacontrol_sound_set_volume(FMediaControl,volume,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaControl.start(a_position: Pmediacontrol_Position);
begin
  VLCGetProcAddress('mediacontrol_start',@mediacontrol_start);
  mediacontrol_start(FMediaControl,a_position,@Fexception.FException);
  FException.Check;
end;

procedure TVLCMediaControl.stop;
begin
  VLCGetProcAddress('mediacontrol_stop',@mediacontrol_stop);
  mediacontrol_stop(FMediaControl,@Fexception.FException);
  FException.Check;
end;

{$ENDREGION}

{ TMediaControlException }

{$REGION 'VLCMediaControlException'}

constructor TVLCMediaControlException.Create;
begin
  inherited Create;
  VLCGetProcAddress('mediacontrol_exception_create',@mediacontrol_exception_create);
  FException:=mediacontrol_exception_create;
end;

Destructor TVLCMediaControlException.Destroy;
begin
  Exception_Free;
  Inherited Destroy;
end;

procedure TVLCMediaControlException.Check;
begin
  if FException.code <> 0 then
    raise Exception.CreateFmt('Erreur %s',[String(FException.message)]);
end;

procedure TVLCMediaControlException.cleanup;
begin
  VLCGetProcAddress('mediacontrol_exception_cleanup',@mediacontrol_exception_cleanup);
  mediacontrol_exception_cleanup(FException);
end;

procedure TVLCMediaControlException.Exception_free;
begin
  VLCGetProcAddress('mediacontrol_exception_free',@mediacontrol_exception_free);
  mediacontrol_exception_free(FException);
end;

procedure TVLCMediaControlException.init;
begin
  VLCGetProcAddress('mediacontrol_exception_init',@mediacontrol_exception_init);
  mediacontrol_exception_init(FException);
end;

{$ENDREGION}

////////////////////////////////////////////////////////////////////////////////
///
///
///
////////////////////////////////////////////////////////////////////////////////


{ TVlcLog }

{$REGION 'VLCLog'}

constructor TVlcLog.Create(aLog: Plibvlc_log_t);
begin
  Inherited Create;
  FLog:=aLog;
  FException :=TVLCException.Create;
end;

destructor TVlcLog.Destroy;
begin
  Close;
  FException.Free;
  inherited;
end;

procedure TVlcLog.clear;
begin
  VLCGetProcAddress('libvlc_log_clear',@libvlc_log_clear);
  libvlc_log_clear(Flog);
end;

procedure TVlcLog.close;
begin
  VLCGetProcAddress('libvlc_log_close',@libvlc_log_close);
  libvlc_log_close(FLog);
end;

function TVlcLog.count: longword;
begin
  VLCGetProcAddress('libvlc_log_count',@libvlc_log_count);
  Result:=libvlc_log_count(FLog);
end;

function TVlcLog.get_iterator: TVlcLogIterator;
begin
  VLCGetProcAddress('libvlc_log_get_iterator',@libvlc_log_get_iterator);
  Result:=TVlcLogIterator.Create( libvlc_log_get_iterator(FLog,@FException.FException));
  FException.Check;
end;

{$ENDREGION}

{ TVlcLogIterator }

{$REGION 'VLCLogIterator'}

constructor TVlcLogIterator.Create(aIter: Plibvlc_log_iterator_t);
begin
  Inherited Create;
  FException :=TVLCException.Create;
  FIter:=aIter;
end;

Destructor TVlcLogIterator.Destroy;
begin
  FreeIterator;
  FException.Free;
  inherited Destroy;
end;

procedure TVlcLogIterator.freeIterator;
begin
  VLCGetProcAddress('libvlc_log_iterator_free',@libvlc_log_iterator_free);
  libvlc_log_iterator_free(FIter);
end;

function TVlcLogIterator.has_next: Longbool;
begin
  VLCGetProcAddress('libvlc_log_iterator_has_next',@libvlc_log_iterator_has_next);
  result:=libvlc_log_iterator_has_next(FIter);
end;

function TVlcLogIterator.next(
  p_buffer: Plibvlc_log_message_t): Plibvlc_log_message_t;
begin
  VLCGetProcAddress('libvlc_log_iterator_next',@libvlc_log_iterator_next);
  Result:=libvlc_log_iterator_next(FIter,p_buffer,@FException.FException);
  FException.Check;

end;

{$ENDREGION}

end.
