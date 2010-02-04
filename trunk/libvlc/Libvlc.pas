unit Libvlc;

(*****************************************************************************
 * libvlc.h:  libvlc external API
 *****************************************************************************
 * Copyright (C) 1998-2009 the VideoLAN team
 * $Id: c3cd38d045fd20f6ef8023977b92613637ff5fb1 $
 *
 * Authors: Clément Stenac <zorglub@videolan.org>
 *          Jean-Paul Saman <jpsaman@videolan.org>
 *          Pierre d'Herbemont <pdherbemont@videolan.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************)

{ VideoLAN libvcl.dll (0.8.6b) Interface for Delphi (c)2007 by Paul TOTH
  - Modified by Norbert Mereg     libvcl.dll (0.8.6i)                       }

// http://wiki.videolan.org/ExternalAPI#VLC_Control

interface
uses
  Windows;

const
 LibName = 'libvlc.dll';

{$REGION 'Binding function'}

// Structures
type
  libvlc_exception = record
    Code    : integer;
    Message : pAnsichar;
  end;

  (***************************************************************************
   * Opaque structures for libvlc API
   ***************************************************************************)
  vlc_thread_t = packed record
      handle: THANDLE;
      cancel_event: THANDLE;
  end;

  vlc_mutex_t = packed record
   initialized: LONGint;
   mutex: TRTLCriticalSection; //CRITICALSECTION;
  end;

  Pvlm_t =^vlm_t;
  vlm_t = packed record
      {$I VLC_COMMON_MEMBERS.inc}

      lock: vlc_mutex_t;
      thread: vlc_thread_t;

      (* *)
      i_id: int64;

      (* Vod server (used by media) *)
      i_vod: Integer;
      p_vod: Pointer; //Pvod_t;

      (* Media list *)
      i_media: Integer;
      media: Pointer; //PPvlm_media_sys_t;

      (* Schedule list *)
      i_schedule: Integer;
      schedule: Pointer;//PPvlm_schedule_sys_t;
  end;

  libvlc_vlm_release_func_t = procedure(inst: Pointer{Plibvlc_instance_t}); cdecl;

  Plibvlc_vlm_t = ^libvlc_vlm_t;
  libvlc_vlm_t = packed record

      p_vlm: Pvlm_t;
      p_event_manager: Pointer; //Plibvlc_event_manager_t;
      pf_release: libvlc_vlm_release_func_t;
  end; // libvlc_vlm_t;

  (*****************************************************************************
   * libvlc_internal_instance_t
   *****************************************************************************
   * This structure is a LibVLC instance, for use by libvlc core and plugins
   *****************************************************************************)
  hotkey = packed record

      psz_action: PAnsiChar;
      i_action: Integer;
      i_key: Integer;
  end;
  Photkey = ^hotkey;

  Plibvlc_int_t = ^libvlc_int_t;
  libvlc_int_t = packed record
      {$I VLC_COMMON_MEMBERS.inc}

      (* Structure storing the action name / key associations *)
     p_hotkeys : photkey;
  end;

  libvlc_instance_t = packed record
      p_libvlc_int: Plibvlc_int_t;
      libvlc_vlm: libvlc_vlm_t;
      ref_count: Cardinal;
      verbosity: Integer;
      instance_lock: vlc_mutex_t;
      p_callback_list: Pointer; //Plibvlc_callback_entry_list_t;
  end;
  Plibvlc_instance_t = ^libvlc_instance_t;

  (*****************************************************************************
   * Exceptions
   *****************************************************************************)

  (** \defgroup libvlc_exception libvlc_exception
   * \ingroup libvlc_core
   * LibVLC Exceptions handling
   * @{
   *)

  Plibvlc_exception_t = ^libvlc_exception_t;
  libvlc_exception_t = record
    b_raised: Integer;
    i_code: Integer;
    psz_message: PAnsiChar;
  end; // libvlc_exception_t;

  (*****************************************************************************
   * Media List
   *****************************************************************************)

  Plibvlc_media_list_t = ^libvlc_media_list_t;
  libvlc_media_list_t= record
  end; // libvlc_media_list_t ;

  Plibvlc_media_list_view_t = ^libvlc_media_list_view_t;
  libvlc_media_list_view_t= record
  end; //libvlc_media_list_view_t ;

  (*****************************************************************************
   * Time
   *****************************************************************************)
  (** \defgroup libvlc_time libvlc_time
   * \ingroup libvlc_core
   * LibVLC Time support in libvlc
   * @{
   *)

  libvlc_time_t = int64;

  (*****************************************************************************
   * Media Descriptor
   *****************************************************************************)
  (** \defgroup libvlc_media libvlc_media
   * \ingroup libvlc
   * LibVLC Media Descriptor handling
   * @{
   *)


  (*****************************************************************************
   * Playlist
   *****************************************************************************)
  (** \defgroup libvlc_playlist libvlc_playlist (Deprecated)
   * \ingroup libvlc
   * LibVLC Playlist handling (Deprecated)
   * @deprecated Use media_list
   * @{
   *)

  Plibvlc_playlist_item_t = ^libvlc_playlist_item_t;
  libvlc_playlist_item_t = packed record
    i_id: Integer;
    psz_uri: PAnsiChar;
    psz_name: PAnsiChar;
  end; // libvlc_playlist_item_t

  (*****************************************************************************
   * Message log handling
   *****************************************************************************)

  (** \defgroup libvlc_log libvlc_log
   * \ingroup libvlc_core
   * LibVLC Message Logging
   * @{
   *)

  (** This structure is opaque. It represents a libvlc log instance *)
  Plibvlc_log_t = ^libvlc_log_t;
  libvlc_log_t = record
  end;

  (** This structure is opaque. It represents a libvlc log iterator *)
  Plibvlc_log_iterator_t = ^libvlc_log_iterator_t;
  libvlc_log_iterator_t = record
  end;

  Plibvlc_log_message_t = ^libvlc_log_message_t;
  libvlc_log_message_t = packed record
    sizeof_msg: Cardinal;    (* sizeof() of message structure, must be filled in by user *)
    i_severity: Integer;    (* 0=INFO, 1=ERR, 2=WARN, 3=DBG *)
    psz_type: PAnsiChar;      (* module type *)
    psz_name: PAnsiChar;      (* module name *)
    psz_header: PAnsiChar;    (* optional header *)
    psz_message: PAnsiChar;   (* message *)
  end;// libvlc_log_message_t

  //////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  //////////////////////////////////////////////////////////////////////////////

  libvlc_instance = pointer;
  libvlc_input    = pointer;

var
  (*****************************************************************************
   * Exception handling
   *****************************************************************************)
  (** \defgroup libvlc_exception libvlc_exception
   * \ingroup libvlc_core
   * LibVLC Exceptions handling
   * @{
   *)

  (**
   * Initialize an exception structure. This can be called several times to
   * reuse an exception structure.
   *
   * \param p_exception the exception to initialize
   *)
  libvlc_exception_init : procedure ( p_exception: Plibvlc_exception_t); cdecl;

  (**
   * Has an exception been raised?
   *
   * \param p_exception the exception to query
   * \return 0 if the exception was raised, 1 otherwise
   *)

  libvlc_exception_raised : function ( const p_exception: Plibvlc_exception_t):longbool; cdecl;

  (**
   * Raise an exception.
   *
   * \param p_exception the exception to raise
   *)
  libvlc_exception_raise : procedure( p_exception: Plibvlc_exception_t); cdecl;

  (**
   * Clear an exception object so it can be reused.
   * The exception object must have be initialized.
   *
   * \param p_exception the exception to clear
   *)
  libvlc_exception_clear: procedure( p_exception: Plibvlc_exception_t); cdecl;

  (**
   * Get an exception's message.
   *
   * \param p_exception the exception to query
   * \return the exception message or NULL if not applicable (exception not
   *         raised, for example)
   *)

  libvlc_exception_get_message: function( p_exception: Plibvlc_exception_t):PAnsiChar; cdecl;
  (*****************************************************************************
   * Error handling
   *****************************************************************************)
  (** \defgroup libvlc_error libvlc_error
   * \ingroup libvlc_core
   * LibVLC error handling
   * @{
   *)

  (**
   * A human-readable error message for the last LibVLC error in the calling
   * thread. The resulting string is valid until another error occurs (at least
   * until the next LibVLC call).
   *
   * @warning
   * This will be NULL if there was no error.
   *)
  libvlc_errmsg : function:PAnsichar; cdecl;

  (**
   * Clears the LibVLC error status for the current thread. This is optional.
   * By default, the error status is automatically overriden when a new error
   * occurs, and destroyed when the thread exits.
   *)
  libvlc_clearerr : procedure; cdecl;

  (**
   * Sets the LibVLC error status and message for the current thread.
   * Any previous error is overriden.
   * @return a nul terminated string in any case
   *)
  //libvlc_vprinterr: function (const fmt: PAnsiChar;  ap: va_list):Pchar; cdecl;

  (**
   * Sets the LibVLC error status and message for the current thread.
   * Any previous error is overriden.
   * @return a nul terminated string in any case
   *)
  //libvlc_printerr: function (fmt: PChar;  ...):PChar;

  (**@} *)

  (*****************************************************************************
   * Core handling
   *****************************************************************************)

  (** \defgroup libvlc_core libvlc_core
   * \ingroup libvlc
   * LibVLC Core
   * @{
   *)

  (**
   * Create and initialize a libvlc instance.
   *
   * \param argc the number of arguments
   * \param argv command-line-type arguments. argv[0] must be the path of the
   *        calling program.
   * \param p_e an initialized exception pointer
   * \return the libvlc instance
   *)

  libvlc_new : Function ( argc: Integer;  args: PPAnsiChar;
                          p_exception: Plibvlc_exception_t):Plibvlc_instance_t; cdecl;

  (**
   * Decrement the reference count of a libvlc instance, and destroy it
   * if it reaches zero.
   *
   * \param p_instance the instance to destroy
   *)
  libvlc_release : procedure( instance: Plibvlc_instance_t); cdecl;

  (**
   * Increments the reference count of a libvlc instance.
   * The initial reference count is 1 after libvlc_new() returns.
   *
   * \param p_instance the instance to reference
   *)
  libvlc_retain: procedure( instance: Plibvlc_instance_t); cdecl;

  (**
   * Try to start a user interface for the libvlc instance.
   *
   * \param p_instance the instance
   * \param name interface name, or NULL for default
   * \param p_exception an initialized exception pointer
   * \return 0 on success, -1 on error.
   *)

   libvlc_add_intf: function ( p_instance: Plibvlc_instance_t;  const name: PAnsiChar;
                       p_exception: Plibvlc_exception_t):integer; cdecl;

  (**
   * Waits until an interface causes the instance to exit.
   * You should start at least one interface first, using libvlc_add_intf().
   *
   * \param p_instance the instance
   *)

  libvlc_wait : procedure( p_instance: Plibvlc_instance_t); cdecl;

  (**
   * Retrieve libvlc version.
   *
   * Example: "0.9.0-git Grishenko"
   *
   * \return a string containing the libvlc version
   *)
   libvlc_get_version : function:PAnsichar; cdecl;

  (**
   * Retrieve libvlc compiler version.
   *
   * Example: "gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu6)"
   *
   * \return a string containing the libvlc compiler version
   *)
  libvlc_get_compiler : function :PAnsichar; cdecl;

  (**
   * Retrieve libvlc changeset.
   *
   * Example: "aa9bce0bc4"
   *
   * \return a string containing the libvlc changeset
   *)
  libvlc_get_changeset: function:PAnsichar; cdecl;

type
  Pvlc_object_t = ^vlc_object_t;
  vlc_object_t = record
  end;

var
  (**
   * Get the internal main VLC object.
   * Use of this function is usually a hack and should be avoided.
   * @note
   * You will need to link with libvlccore to make any use of the underlying VLC
   * object. The libvlccore programming and binary interfaces are not stable.
   * @warning
   * Remember to release the object with vlc_object_release().
   *
   * \param p_instance the libvlc instance
   * @return a VLC object of type "libvlc"
   *)
  libvlc_get_vlc_instance: function (p_instance: Plibvlc_instance_t):Pvlc_object_t; cdecl;

  (**
   * Frees an heap allocation ( char * ) returned by a LibVLC API.
   * If you know you're using the same underlying C run-time as the LibVLC
   * implementation, then you can call ANSI C free() directly instead.
   *
   * \param ptr the pointer
   *)
  libvlc_free : procedure( ptr: Pointer); cdecl;

  (** @}*)

  (*****************************************************************************
   * Event handling
   *****************************************************************************)

  (** \defgroup libvlc_event libvlc_event
   * \ingroup libvlc_core
   * LibVLC Events
   * @{
   *)

type
   Plibvlc_media_t = ^libvlc_media_t;
   libvlc_media_t = record
   end;

  (* Meta Handling *)
  (** defgroup libvlc_meta libvlc_meta
   * \ingroup libvlc_media
   * LibVLC Media Meta
   * @{
   *)

  libvlc_meta_t = (
      libvlc_meta_Title,
      libvlc_meta_Artist,
      libvlc_meta_Genre,
      libvlc_meta_Copyright,
      libvlc_meta_Album,
      libvlc_meta_TrackNumber,
      libvlc_meta_Description,
      libvlc_meta_Rating,
      libvlc_meta_Date,
      libvlc_meta_Setting,
      libvlc_meta_URL,
      libvlc_meta_Language,
      libvlc_meta_NowPlaying,
      libvlc_meta_Publisher,
      libvlc_meta_EncodedBy,
      libvlc_meta_ArtworkURL,
      libvlc_meta_TrackID
      (* Add new meta types HERE *)
  ); // libvlc_meta_t

  (**
   * Note the order of libvlc_state_t enum must match exactly the order of
   * @see mediacontrol_PlayerStatus, @see input_state_e enums,
   * and VideoLAN.LibVLC.State (at bindings/cil/src/media.cs).
   *
   * Expected states by web plugins are:
   * IDLE/CLOSE=0, OPENING=1, BUFFERING=2, PLAYING=3, PAUSED=4,
   * STOPPING=5, ENDED=6, ERROR=7
   *)
type
  libvlc_state_t = (
      libvlc_NothingSpecial=0,
      libvlc_Opening,
      libvlc_Buffering,
      libvlc_Playing,
      libvlc_Paused,
      libvlc_Stopped,
      libvlc_Ended,
      libvlc_Error
  ); //libvlc_state_t

  libvlc_media_option_t = (
      libvlc_media_option_trusted = $2,
      libvlc_media_option_unique = $100
  ); // libvlc_media_option_t

  (**
   * Event manager that belongs to a libvlc object, and from whom events can
   * be received.
   *)
type
  Plibvlc_event_manager_t = ^libvlc_event_manager_t;
  libvlc_event_manager_t = record
  end;

      (* Append new event types at the end. Do not remove, insert or
       * re-order any entry. The cpp will prepend libvlc_ to the symbols. *)
   event_type_specific = (
       MediaMetaChanged ,
       MediaSubItemAdded ,
       MediaDurationChanged ,
       MediaPreparsedChanged ,
       MediaFreed,
       MediaStateChanged ,

       MediaPlayerNothingSpecial ,
       MediaPlayerOpening ,
       MediaPlayerBuffering ,
       MediaPlayerPlaying ,
       MediaPlayerPaused ,
       MediaPlayerStopped ,
       MediaPlayerForward ,
       MediaPlayerBackward ,
       MediaPlayerEndReached ,
       MediaPlayerEncounteredError ,
       MediaPlayerTimeChanged ,
       MediaPlayerPositionChanged ,
       MediaPlayerSeekableChanged ,
       MediaPlayerPausableChanged ,

       MediaListItemAdded ,
       MediaListWillAddItem ,
       MediaListItemDeleted ,
       MediaListWillDeleteItem ,

       MediaListViewItemAdded ,
       MediaListViewWillAddItem ,
       MediaListViewItemDeleted ,
       MediaListViewWillDeleteItem ,

       MediaListPlayerPlayed ,
       MediaListPlayerNextItemSet ,
       MediaListPlayerStopped ,

       MediaDiscovererStarted ,
       MediaDiscovererEnded ,

       MediaPlayerTitleChanged ,
       MediaPlayerSnapshotTaken ,
       MediaPlayerLengthChanged ,

       VlmMediaAdded ,
       VlmMediaRemoved,
       VlmMediaChanged ,
       VlmMediaInstanceStarted ,
       VlmMediaInstanceStopped ,
       VlmMediaInstanceStatusInit ,
       VlmMediaInstanceStatusOpening ,
       VlmMediaInstanceStatusPlaying ,
       VlmMediaInstanceStatusPause ,
       VlmMediaInstanceStatusEnd ,
       VlmMediaInstanceStatusError
      (* New event types HERE *)
  );

  (**
   * An Event
   * \param type the even type
   * \param p_obj the sender object
   * \param u Event dependent content
   *)

type
  libvlc_event_type_t = uint32;

  Plibvlc_event_t = ^libvlc_event_t;
  libvlc_event_t = record
      _type: libvlc_event_type_t;
      p_obj: Pointer;
      case u : event_type_specific of

          (* media descriptor *)
          mediametachanged :
          (
              meta_type: libvlc_meta_t;
          ) ;
          mediasubitemadded :
          (
              new_child: Plibvlc_media_t;
          ) ;
          mediadurationchanged :
          (
              new_duration: int64;
          ) ;
          mediapreparsedchanged :
          (
              new_status: Integer;
          ) ;
          mediafreed :
          (
              md: Plibvlc_media_t;
          ) ;
          mediastatechanged :
          (
              new_state: libvlc_state_t;
          ) ;

          (* media instance *)
          mediaplayerpositionchanged :
          (
              new_position: Single;
          ) ;
          mediaplayertimechanged :
          (
              new_time: libvlc_time_t;
          ) ;
          mediaplayertitlechanged :
          (
              new_title: Integer;
          ) ;
          mediaplayerseekablechanged :
          (
              new_seekable: Integer;
          ) ;
          mediaplayerpausablechanged :
          (
              new_pausable: Integer;
          ) ;

          (* media list *)
          medialistitemadded,
          medialistwilladditem,
          medialistitemdeleted,
          medialistwilldeleteitem,
          (* media list view *)
          MediaListViewItemAdded,
          medialistviewwilladditem,
          medialistviewitemdeleted,
          medialistviewwilldeleteitem:
          (
              item: Plibvlc_media_t;
              index: Integer;
          ) ;

          (* media list player *)
          medialistplayernextitemset :
          (
              item1: Plibvlc_media_t;
          ) ;

          (* snapshot taken *)
          mediaplayersnapshottaken :
          (
               psz_filename: PAnsiChar;
          )  ;

          (* Length changed *)
          mediaplayerlengthchanged :
          (
              new_length: libvlc_time_t;
          ) ;

          (* VLM media *)
          //vlmmediaevent :
                 VlmMediaAdded ,
         VlmMediaRemoved,
         VlmMediaChanged ,
         VlmMediaInstanceStarted ,
         VlmMediaInstanceStopped ,
         VlmMediaInstanceStatusInit ,
         VlmMediaInstanceStatusOpening ,
         VlmMediaInstanceStatusPlaying ,
         VlmMediaInstanceStatusPause ,
         VlmMediaInstanceStatusEnd ,
         VlmMediaInstanceStatusError:
        (
              psz_media_name: PAnsiChar;
              psz_instance_name: PAnsiChar;
          ) ;

  end;




  (**
   * Callback function notification
   * \param p_event the event triggering the callback
   *)

  libvlc_callback_t = procedure (const Event: Plibvlc_event_t;  Data: Pointer); cdecl;


Var
  (**
   * Register for an event notification.
   *
   * \param p_event_manager the event manager to which you want to attach to.
   *        Generally it is obtained by vlc_my_object_event_manager() where
   *        my_object is the object you want to listen to.
   * \param i_event_type the desired event to which we want to listen
   * \param f_callback the function to call when i_event_type occurs
   * \param user_data user provided data to carry with the event
   * \param p_e an initialized exception pointer
   *)
  libvlc_event_attach : procedure ( p_event_manager: Plibvlc_event_manager_t;
                                           i_event_type: libvlc_event_type_t;
                                           f_callback: libvlc_callback_t;
                                           user_data: Pointer;
                                           p_e: Plibvlc_exception_t); cdecl;

  (**
   * Unregister an event notification.
   *
   * \param p_event_manager the event manager
   * \param i_event_type the desired event to which we want to unregister
   * \param f_callback the function to call when i_event_type occurs
   * \param p_user_data user provided data to carry with the event
   * \param p_e an initialized exception pointer
   *)
   libvlc_event_detach : procedure( p_event_manager: Plibvlc_event_manager_t;
                                           i_event_type: libvlc_event_type_t;
                                           f_callback: libvlc_callback_t;
                                           p_user_data: Pointer;
                                           p_e: Plibvlc_exception_t); cdecl;

  (**
   * Get an event's type name.
   *
   * \param i_event_type the desired event
   *)
   libvlc_event_type_name : function( event_type: libvlc_event_type_t):Pansichar;

  (** @} *)

  (*****************************************************************************
   * Message log handling
   *****************************************************************************)

  (** \defgroup libvlc_log libvlc_log
   * \ingroup libvlc_core
   * LibVLC Message Logging
   * @{
   *)

  (**
   * Return the VLC messaging verbosity level.
   *
   * \param p_instance libvlc instance
   * \return verbosity level for messages
   *)
  libvlc_get_log_verbosity : function ( const p_instance: Plibvlc_instance_t):longword; cdecl;

  (**
   * Set the VLC messaging verbosity level.
   *
   * \param p_instance libvlc log instance
   * \param level log level
   *)
  libvlc_set_log_verbosity : procedure( p_instance: Plibvlc_instance_t;  level: Cardinal); cdecl;

  (**
   * Open a VLC message log instance.
   *
   * \param p_instance libvlc instance
   * \param p_e an initialized exception pointer
   * \return log message instance
   *)
  libvlc_log_open: function( instance: Plibvlc_instance_t;  e: Plibvlc_exception_t):Plibvlc_log_t; cdecl;

  (**
   * Close a VLC message log instance.
   *
   * \param p_log libvlc log instance or NULL
   *)
  libvlc_log_close: procedure( p_log: Plibvlc_log_t); cdecl;

  (**
   * Returns the number of messages in a log instance.
   *
   * \param p_log libvlc log instance or NULL
   * \return number of log messages, 0 if p_log is NULL
   *)
  libvlc_log_count: function ( const p_log: Plibvlc_log_t):longword; cdecl;

  (**
   * Clear a log instance.
   *
   * All messages in the log are removed. The log should be cleared on a
   * regular basis to avoid clogging.
   *
   * \param p_log libvlc log instance or NULL
   *)
  libvlc_log_clear: procedure ( p_log: Plibvlc_log_t); cdecl;

  (**
   * Allocate and returns a new iterator to messages in log.
   *
   * \param p_log libvlc log instance
   * \param p_e an initialized exception pointer
   * \return log iterator object
   *)
  libvlc_log_get_iterator: function( const log: Plibvlc_log_t;  e: Plibvlc_exception_t):Plibvlc_log_iterator_t; cdecl;

  (**
   * Release a previoulsy allocated iterator.
   *
   * \param p_iter libvlc log iterator or NULL
   *)
  libvlc_log_iterator_free : procedure( p_iter: Plibvlc_log_iterator_t); cdecl;

  (**
   * Return whether log iterator has more messages.
   *
   * \param p_iter libvlc log iterator or NULL
   * \return true if iterator has more message objects, else false
   *)
  libvlc_log_iterator_has_next: function ( const p_iter: Plibvlc_log_iterator_t):longbool; cdecl;

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
  libvlc_log_iterator_next : function( p_iter: Plibvlc_log_iterator_t;
                                       p_buffer: Plibvlc_log_message_t;
                                       p_e: Plibvlc_exception_t):Plibvlc_log_message_t; cdecl;

  (** @} *)

  (*****************************************************************************
   * media
   *****************************************************************************)
  (** \defgroup libvlc_media libvlc_media
   * \ingroup libvlc
   * LibVLC Media
   * @{
   *)


  (** @}*)


var
  (**
   * Create a media with the given MRL.
   *
   * \param p_instance the instance
   * \param psz_mrl the MRL to read
   * \param p_e an initialized exception pointer
   * \return the newly created media
   *)
    libvlc_media_new : function ( p_instance: Plibvlc_instance_t;
                                  const psz_mrl: PAnsiChar;
                                  p_e: Plibvlc_exception_t):Plibvlc_media_t; cdecl;

  (**
   * Create a media as an empty node with the passed name.
   *
   * \param p_instance the instance
   * \param psz_name the name of the node
   * \param p_e an initialized exception pointer
   * \return the new empty media
   *)
   libvlc_media_new_as_node : function ( p_instance: Plibvlc_instance_t;
                                         psz_name: PAnsiChar;
                                         p_e: Plibvlc_exception_t):Plibvlc_media_t; cdecl;

  (**
   * Add an option to the media.
   *
   * This option will be used to determine how the media_player will
   * read the media. This allows to use VLC's advanced
   * reading/streaming options on a per-media basis.
   *
   * The options are detailed in vlc --long-help, for instance "--sout-all"
   *
   * \param p_instance the instance
   * \param ppsz_options the options (as a string)
   *)
  libvlc_media_add_option : procedure ( p_md: Plibvlc_media_t;
                                     ppsz_options: PAnsiChar); cdecl;

  (**
   * Add an option to the media from an untrusted source.
   *
   * This option will be used to determine how the media_player will
   * read the media. This allows to use VLC's advanced
   * reading/streaming options on a per-media basis.
   *
   * The options are detailed in vlc --long-help, for instance "--sout-all"
   *
   * \param p_instance the instance
   * \param ppsz_options the options (as a string)
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_add_option_untrusted: procedure( p_md: Plibvlc_media_t;
                                   ppsz_options: PansiChar;
                                   p_e: Plibvlc_exception_t); cdecl;
  (**
   * Add an option to the media with configurable flags.
   *
   * This option will be used to determine how the media_player will
   * read the media. This allows to use VLC's advanced
   * reading/streaming options on a per-media basis.
   *
   * The options are detailed in vlc --long-help, for instance "--sout-all"
   *
   * \param p_instance the instance
   * \param ppsz_options the options (as a string)
   * \param i_flags the flags for this option
   *)
   libvlc_media_add_option_flag : procedure( p_md: Plibvlc_media_t;
                                     ppsz_options: PAnsiChar;
                                     i_flags: libvlc_media_option_t); cdecl;


  (**
   * Retain a reference to a media descriptor object (libvlc_media_t). Use
   * libvlc_media_release() to decrement the reference count of a
   * media descriptor object.
   *
   * \param p_meta_desc a media descriptor object.
   *)
  libvlc_media_retain : procedure ( p_meta_desc: Plibvlc_media_t); cdecl;

  (**
   * Decrement the reference count of a media descriptor object. If the
   * reference count is 0, then libvlc_media_release() will release the
   * media descriptor object. It will send out an libvlc_MediaFreed event
   * to all listeners. If the media descriptor object has been released it
   * should not be used again.
   *
   * \param p_meta_desc a media descriptor object.
   *)
  libvlc_media_release : procedure( p_meta_desc: Plibvlc_media_t); cdecl;


  (**
   * Get the media resource locator (mrl) from a media descriptor object
   *
   * \param p_md a media descriptor object
   * \return string with mrl of media descriptor object
   *)
   libvlc_media_get_mrl: function( p_md: Plibvlc_media_t):PansiChar; cdecl;

  (**
   * Duplicate a media descriptor object.
   *
   * \param p_meta_desc a media descriptor object.
   *)
  libvlc_media_duplicate : function ( p_md: Plibvlc_media_t):Plibvlc_media_t; cdecl;

  (**
   * Read the meta of the media.
   *
   * \param p_meta_desc the media to read
   * \param e_meta the meta to read
   * \return the media's meta
   *)
  libvlc_media_get_meta : function ( p_meta_desc: Plibvlc_media_t;
                                     e_meta: libvlc_meta_t):PansiChar; cdecl;

  (**
   * Get current state of media descriptor object. Possible media states
   * are defined in libvlc_structures.c ( libvlc_NothingSpecial=0,
   * libvlc_Opening, libvlc_Buffering, libvlc_Playing, libvlc_Paused,
   * libvlc_Stopped, libvlc_Ended,
   * libvlc_Error).
   *
   * @see libvlc_state_t
   * \param p_meta_desc a media descriptor object
   * \return state of media descriptor object
   *)
  libvlc_media_get_state: function( p_meta_desc: Plibvlc_media_t):libvlc_state_t; cdecl;


  (**
   * Get subitems of media descriptor object. This will increment
   * the reference count of supplied media descriptor object. Use
   * libvlc_media_list_release() to decrement the reference counting.
   *
   * \param p_md media descriptor object
   * \return list of media descriptor subitems or NULL
   *)

  (* This method uses libvlc_media_list_t, however, media_list usage is optionnal
   * and this is here for convenience *)
  //#define VLC_FORWARD_DECLARE_OBJECT(a) struct a

  libvlc_media_subitems : function( p_md: Plibvlc_media_t):Plibvlc_media_list_t; cdecl;

  (**
   * Get event manager from media descriptor object.
   * NOTE: this function doesn't increment reference counting.
   *
   * \param p_md a media descriptor object
   * \return event manager object
   *)

  libvlc_media_event_manager: function ( p_md: Plibvlc_media_t):Plibvlc_event_manager_t; cdecl;

  (**
   * Get duration (in ms) of media descriptor object item.
   *
   * \param p_md media descriptor object
   * \param p_e an initialized exception object
   * \return duration of media item
   *)

  libvlc_media_get_duration: function( p_md: Plibvlc_media_t;
                                           p_e: Plibvlc_exception_t):libvlc_time_t; cdecl;

  (**
   * Get preparsed status for media descriptor object.
   *
   * \param p_md media descriptor object
   * \return true if media object has been preparsed otherwise it returns false
   *)
  libvlc_media_is_preparsed: function( p_md: Plibvlc_media_t):integer; cdecl;

  (**
   * Sets media descriptor's user_data. user_data is specialized data
   * accessed by the host application, VLC.framework uses it as a pointer to
   * an native object that references a libvlc_media_t pointer
   *
   * \param p_md media descriptor object
   * \param p_new_user_data pointer to user data
   *)
  libvlc_media_set_user_data: procedure( p_md: Plibvlc_media_t;
                                             p_new_user_data: Pointer); cdecl;

  (**
   * Get media descriptor's user_data. user_data is specialized data
   * accessed by the host application, VLC.framework uses it as a pointer to
   * an native object that references a libvlc_media_t pointer
   *
   * \param p_md media descriptor object
   *)
  libvlc_media_get_user_data: function( p_md: Plibvlc_media_t):Pointer ; cdecl;

  (** @}*)
  (*****************************************************************************
   * Media Player
   *****************************************************************************)
  (** \defgroup libvlc_media_player libvlc_media_player
   * \ingroup libvlc
   * LibVLC Media Player, object that let you play a media
   * in a custom drawable
   * @{
   *)

type
  Plibvlc_media_player_t = ^libvlc_media_player_t;
  libvlc_media_player_t = record
  end; //libvlc_media_player_t;

  (**
   * Description for video, audio tracks and subtitles. It contains
   * id, name (description string) and pointer to next record.
   *)
  Plibvlc_track_description_t = ^libvlc_track_description_t;
  libvlc_track_description_t = record
    i_id: Integer;
    psz_name: PAnsiChar;
    p_next: Plibvlc_track_description_t;
  end; // libvlc_track_description_t;

  (**
   * Description for audio output. It contains
   * name, description and pointer to next record.
   *)
  Plibvlc_audio_output_t = ^libvlc_audio_output_t;
  libvlc_audio_output_t= record
    psz_name: PansiChar;
    psz_description: PansiChar;
    p_next: Plibvlc_audio_output_t;
  end; // libvlc_audio_output_t;

  (**
   * Rectangle type for video geometry
   *)
  libvlc_rectangle_t= record
      top, left: Integer;
      bottom, right: Integer;
  end;
  Plibvlc_rectangle_t = ^libvlc_rectangle_t;

  (**
   * Marq int options definition
   *)
  libvlc_video_marquee_int_option_t = ( libvlc_marquee_Enabled = 0,
      libvlc_marquee_Color,
      libvlc_marquee_Opacity,
      libvlc_marquee_Position,
      libvlc_marquee_Refresh,
      libvlc_marquee_Size,
      libvlc_marquee_Timeout,
      libvlc_marquee_X,
      libvlc_marquee_Y
  ); // libvlc_video_marquee_int_option_t;

  (**
   * Marq string options definition
   *)
  libvlc_video_marquee_string_option_t = (
      libvlc_marquee_Text = 0
  );// libvlc_video_marquee_string_option_t;


var
  (**
   * Create an empty Media Player object
   *
   * \param p_libvlc_instance the libvlc instance in which the Media Player
   *        should be created.
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_new: function( Instance : Plibvlc_instance_t; e: Plibvlc_exception_t  ):Plibvlc_media_player_t; cdecl;

  (**
   * Create a Media Player object from a Media
   *
   * \param p_md the media. Afterwards the p_md can be safely
   *        destroyed.
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_new_from_media: function( media: Plibvlc_media_t; e: Plibvlc_exception_t  ):Plibvlc_media_player_t; cdecl;

  (**
   * Release a media_player after use
   * Decrement the reference count of a media player object. If the
   * reference count is 0, then libvlc_media_player_release() will
   * release the media player object. If the media player object
   * has been released, then it should not be used again.
   *
   * \param p_mi the Media Player to free
   *)
  libvlc_media_player_release: procedure( media_player : Plibvlc_media_player_t  ); cdecl;

  (**
   * Retain a reference to a media player object. Use
   * libvlc_media_player_release() to decrement reference count.
   *
   * \param p_mi media player object
   *)
  libvlc_media_player_retain: procedure( media_player: Plibvlc_media_player_t  ); cdecl;

  (**
   * Set the media that will be used by the media_player. If any,
   * previous md will be released.
   *
   * \param p_mi the Media Player
   * \param p_md the Media. Afterwards the p_md can be safely
   *        destroyed.
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_set_media: procedure( media_player : Plibvlc_media_player_t; media: Plibvlc_media_t; e: Plibvlc_exception_t  ); cdecl;

  (**
   * Get the media used by the media_player.
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return the media associated with p_mi, or NULL if no
   *         media is associated
   *)
  libvlc_media_player_get_media: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):Plibvlc_media_t; cdecl;

  (**
   * Get the Event Manager from which the media player send event.
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return the event manager associated with p_mi
   *)
  libvlc_media_player_event_manager:function ( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):Plibvlc_event_manager_t; cdecl;

  (**
   * is_playing
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return 1 if the media player is playing, 0 otherwise
   *)
  libvlc_media_player_is_playing: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):longbool; cdecl;

  (**
   * Play
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_play: procedure( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ); cdecl;

  (**
   * Pause
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_pause:  procedure( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ); cdecl;

  (**
   * Stop
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_stop: procedure( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ); cdecl;

  (**
   * Set the agl handler where the media player should render its video output.
   *
   * \param p_mi the Media Player
   * \param drawable the agl handler
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_set_nsobject: procedure( p_mi: Plibvlc_media_player_t;  drawable: Pointer;  p_e: Plibvlc_exception_t); cdecl;

  (**
   * Get the agl handler previously set with libvlc_media_player_set_agl().
   *
   * \param p_mi the Media Player
   * \return the agl handler or 0 if none where set
   *)
  libvlc_media_player_get_nsobject: function( p_mi: Plibvlc_media_player_t):Pointer; cdecl;

  (**
   * Set the agl handler where the media player should render its video output.
   *
   * \param p_mi the Media Player
   * \param drawable the agl handler
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_set_agl: procedure( p_mi: Plibvlc_media_player_t;  drawable: uint32;  p_e: Plibvlc_exception_t); cdecl;

  (**
   * Get the agl handler previously set with libvlc_media_player_set_agl().
   *
   * \param p_mi the Media Player
   * \return the agl handler or 0 if none where set
   *)
  libvlc_media_player_get_agl: function( p_mi: Plibvlc_media_player_t):uint32; cdecl;

  (**
   * Set an X Window System drawable where the media player should render its
   * video output. If LibVLC was built without X11 output support, then this has
   * no effects.
   *
   * The specified identifier must correspond to an existing Input/Output class
   * X11 window. Pixmaps are <b>not</b> supported. The caller shall ensure that
   * the X11 server is the same as the one the VLC instance has been configured
   * with.
   * If XVideo is <b>not</b> used, it is assumed that the drawable has the
   * following properties in common with the default X11 screen: depth, scan line
   * pad, black pixel. This is a bug.
   *
   * \param p_mi the Media Player
   * \param drawable the ID of the X window
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_set_xwindow:procedure ( p_mi: Plibvlc_media_player_t;  drawable: uint32;  p_e: Plibvlc_exception_t); cdecl;

  (**
   * Get the X Window System window identifier previously set with
   * libvlc_media_player_set_xwindow(). Note that this will return the identifier
   * even if VLC is not currently using it (for instance if it is playing an
   * audio-only input).
   *
   * \param p_mi the Media Player
   * \return an X window ID, or 0 if none where set.
   *)
  //libvlc_media_player_get_xwindow: function( p_mi: Plibvlc_media_player_t):uint32; cdecl;

  (**
   * Set a Win32/Win64 API window handle (HWND) where the media player should
   * render its video output. If LibVLC was built without Win32/Win64 API output
   * support, then this has no effects.
   *
   * \param p_mi the Media Player
   * \param drawable windows handle of the drawable
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_set_hwnd: procedure( p_mi: Plibvlc_media_player_t; drawable: THandle;  p_e: Plibvlc_exception_t); cdecl;

  (**
   * Get the Windows API window handle (HWND) previously set with
   * libvlc_media_player_set_hwnd(). The handle will be returned even if LibVLC
   * is not currently outputting any video to it.
   *
   * \param p_mi the Media Player
   * \return a window handle or NULL if there are none.
   *)
  libvlc_media_player_get_hwnd: function( p_mi: Plibvlc_media_player_t):THandle; cdecl;



  (** \bug This might go away ... to be replaced by a broader system *)

  (**
   * Get the current movie length (in ms).
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return the movie length (in ms).
   *)
  libvlc_media_player_get_length: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ):libvlc_time_t; cdecl;

  (**
   * Get the current movie time (in ms).
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return the movie time (in ms).
   *)
  libvlc_media_player_get_time: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ):libvlc_time_t; cdecl;

  (**
   * Set the movie time (in ms).
   *
   * \param p_mi the Media Player
   * \param the movie time (in ms).
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_set_time: procedure( media_player : Plibvlc_media_player_t; time: libvlc_time_t;  e: Plibvlc_exception_t ); cdecl;

  (**
   * Get movie position.
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return movie position
   *)
  libvlc_media_player_get_position: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ): Single  cdecl;

  (**
   * Set movie position.
   *
   * \param p_mi the Media Player
   * \param f_pos the position
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_set_position: procedure( media_player : Plibvlc_media_player_t; f_pos: Single;  e: Plibvlc_exception_t ); cdecl;

  (**
   * Set movie chapter
   *
   * \param p_mi the Media Player
   * \param i_chapter chapter number to play
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_set_chapter: procedure( media_player : Plibvlc_media_player_t; i_chapter: Integer;  e: Plibvlc_exception_t ); cdecl;

  (**
   * Get movie chapter
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return chapter number currently playing
   *)
  libvlc_media_player_get_chapter: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get movie chapter count
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return number of chapters in movie
   *)
  libvlc_media_player_get_chapter_count: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ):integer; cdecl;

  (**
   * Will the player play
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return boolean
   *)
  libvlc_media_player_will_play: function ( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ):longbool; cdecl;

  (**
   * Get title chapter count
   *
   * \param p_mi the Media Player
   * \param i_title title
   * \param p_e an initialized exception pointer
   * \return number of chapters in title
   *)
  libvlc_media_player_get_chapter_count_for_title: function(
                         media_player : Plibvlc_media_player_t; i_title: Integer; e: Plibvlc_exception_t ):integer; cdecl;

  (**
   * Set movie title
   *
   * \param p_mi the Media Player
   * \param i_title title number to play
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_set_title: procedure( media_player : Plibvlc_media_player_t; i_title: Integer;  e: Plibvlc_exception_t ); cdecl;

  (**
   * Get movie title
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return title number currently playing
   *)
  libvlc_media_player_get_title: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ):integer; cdecl;

  (**
   * Get movie title count
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return title number count
   *)
  libvlc_media_player_get_title_count: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ):integer; cdecl;

  (**
   * Set previous chapter
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_previous_chapter: procedure( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ); cdecl;

  (**
   * Set next chapter
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_next_chapter: procedure( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ); cdecl;

  (**
   * Get movie play rate
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return movie play rate
   *)
  libvlc_media_player_get_rate: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ):single; cdecl;

  (**
   * Set movie play rate
   *
   * \param p_mi the Media Player
   * \param movie play rate to set
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_set_rate: procedure( media_player : Plibvlc_media_player_t; rate: Single;  e: Plibvlc_exception_t ); cdecl;

  (**
   * Get current movie state
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return current movie state as libvlc_state_t
   *)
  libvlc_media_player_get_state: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ):libvlc_state_t; cdecl;

  (**
   * Get movie fps rate
   *
   * \param p_mi the Media Player
   * \param p_e an initialized exception pointer
   * \return frames per second (fps) for this playing movie
   *)
  libvlc_media_player_get_fps: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ):single; cdecl;

  (** end bug *)

  (**
   * Does this media player have a video output?
   *
   * \param p_md the media player
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_has_vout: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t ):longbool; cdecl;

  (**
   * Is this media player seekable?
   *
   * \param p_input the input
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_is_seekable: function( p_mi: Plibvlc_media_player_t;  p_e: Plibvlc_exception_t):longbool; cdecl;

  (**
   * Can this media player be paused?
   *
   * \param p_input the input
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_can_pause: function( p_mi: Plibvlc_media_player_t;  p_e: Plibvlc_exception_t):longbool; cdecl;


  (**
   * Display the next frame
   *
   * \param p_input the libvlc_media_player_t instance
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_player_next_frame: procedure( p_input: Plibvlc_media_player_t;
                                                         p_e: Plibvlc_exception_t); cdecl;



  (**
   * Release (free) libvlc_track_description_t
   *
   * \param p_track_description the structure to release
   *)
  libvlc_track_description_release: procedure( p_track_description: Plibvlc_track_description_t); cdecl;

  (** \defgroup libvlc_video libvlc_video
   * \ingroup libvlc_media_player
   * LibVLC Video handling
   * @{
   *)

  (**
   * Toggle fullscreen status on video output.
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   *)
  libvlc_toggle_fullscreen: procedure( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ); cdecl;

  (**
   * Enable or disable fullscreen on a video output.
   *
   * \param p_mediaplayer the media player
   * \param b_fullscreen boolean for fullscreen status
   * \param p_e an initialized exception pointer
   *)
  libvlc_set_fullscreen: procedure( media_player : Plibvlc_media_player_t; b_fullscreen: BOOL;  e: Plibvlc_exception_t  ); cdecl;

  (**
   * Get current fullscreen status.
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   * \return the fullscreen status (boolean)
   *)
  libvlc_get_fullscreen: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Enable or disable key press events handling, according to the LibVLC hotkeys
   * configuration. By default and for historical reasons, keyboard events are
   * handled by the LibVLC video widget.
   *
   * \note On X11, there can be only one subscriber for key press and mouse
   * click events per window. If your application has subscribed to those events
   * for the X window ID of the video widget, then LibVLC will not be able to
   * handle key presses and mouse clicks in any case.
   *
   * \warning This function is only implemented for X11 at the moment.
   *
   * \param mp the media player
   * \param on true to handle key press events, false to ignore them.
   *)
  libvlc_video_set_key_input: procedure( mp: Plibvlc_media_player_t;  on: Cardinal); cdecl;

  (**
   * Enable or disable mouse click events handling. By default, those events are
   * handled. This is needed for DVD menus to work, as well as a few video
   * filters such as "puzzle".
   *
   * \note See also \func libvlc_video_set_key_input().
   *
   * \warning This function is only implemented for X11 at the moment.
   *
   * \param mp the media player
   * \param on true to handle mouse click events, false to ignore them.
   *)
  libvlc_video_set_mouse_input: procedure( mp: Plibvlc_media_player_t;  on: Cardinal); cdecl;

  (**
   * Get current video height.
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   * \return the video height
   *)
  libvlc_video_get_height: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get current video width.
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   * \return the video width
   *)
  libvlc_video_get_width: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get the current video scaling factor.
   * See also libvlc_video_set_scale().
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   * \return the currently configured zoom factor, or 0. if the video is set
   * to fit to the output window/drawable automatically.
   *)
  libvlc_video_get_scale: function( media_player : Plibvlc_media_player_t;
                                               e: Plibvlc_exception_t ):single; cdecl;

  (**
   * Set the video scaling factor. That is the ratio of the number of pixels on
   * screen to the number of pixels in the original decoded video in each
   * dimension. Zero is a special value; it will adjust the video to the output
   * window/drawable (in windowed mode) or the entire screen.
   *
   * Note that not all video outputs support scaling.
   *
   * \param p_mediaplayer the media player
   * \param i_factor the scaling factor, or zero
   * \param p_e an initialized exception pointer
   *)
  libvlc_video_set_scale: procedure( media_player : Plibvlc_media_player_t; i_factor: Single;
                                              e: Plibvlc_exception_t ); cdecl;

  (**
   * Get current video aspect ratio.
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   * \return the video aspect ratio
   *)
   libvlc_video_get_aspect_ratio: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):PansiChar; cdecl;

  (**
   * Set new video aspect ratio.
   *
   * \param p_mediaplayer the media player
   * \param psz_aspect new video aspect-ratio
   * \param p_e an initialized exception pointer
   *)
  libvlc_video_set_aspect_ratio: procedure ( media_player : Plibvlc_media_player_t; psz_aspect: PansiChar;  e: Plibvlc_exception_t  ); cdecl;

  (**
   * Get current video subtitle.
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   * \return the video subtitle selected
   *)
  libvlc_video_get_spu: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get the number of available video subtitles.
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   * \return the number of available video subtitles
   *)
  libvlc_video_get_spu_count: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get the description of available video subtitles.
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   * \return list containing description of available video subtitles
   *)
  libvlc_video_get_spu_description: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):Plibvlc_track_description_t; cdecl;

  (**
   * Set new video subtitle.
   *
   * \param p_mediaplayer the media player
   * \param i_spu new video subtitle to select
   * \param p_e an initialized exception pointer
   *)
  libvlc_video_set_spu: procedure( media_player : Plibvlc_media_player_t; i_spu: Integer;  e: Plibvlc_exception_t  ); cdecl;

  (**
   * Set new video subtitle file.
   *
   * \param p_mediaplayer the media player
   * \param psz_subtitle new video subtitle file
   * \param p_e an initialized exception pointer
   * \return the success status (boolean)
   *)
    libvlc_video_set_subtitle_file: function( media_player : Plibvlc_media_player_t; psz_subtitle: PansiChar;  e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get the description of available titles.
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   * \return list containing description of available titles
   *)

          libvlc_video_get_title_description: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):Plibvlc_track_description_t; cdecl;

  (**
   * Get the description of available chapters for specific title.
   *
   * \param p_mediaplayer the media player
   * \param i_title selected title
   * \param p_e an initialized exception pointer
   * \return list containing description of available chapter for title i_title
   *)

  libvlc_video_get_chapter_description: function( media_player : Plibvlc_media_player_t; i_title: Integer;  e: Plibvlc_exception_t  ):Plibvlc_track_description_t; cdecl;

  (**
   * Get current crop filter geometry.
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   * \return the crop filter geometry
   *)
    libvlc_video_get_crop_geometry: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):PansiChar; cdecl;

  (**
   * Set new crop filter geometry.
   *
   * \param p_mediaplayer the media player
   * \param psz_geometry new crop filter geometry
   * \param p_e an initialized exception pointer
   *)
  libvlc_video_set_crop_geometry: procedure( media_player : Plibvlc_media_player_t; psz_geometry: PansiChar;  e: Plibvlc_exception_t  ); cdecl;

  (**
   * Toggle teletext transparent status on video output.
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   *)
  libvlc_toggle_teletext: procedure( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ); cdecl;

  (**
   * Get current teletext page requested.
   *
   * \param p_mediaplayer the media player
   * \param p_e an initialized exception pointer
   * \return the current teletext page requested.
   *)
    libvlc_video_get_teletext: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Set new teletext page to retrieve.
   *
   * \param p_mediaplayer the media player
   * \param i_page teletex page number requested
   * \param p_e an initialized exception pointer
   *)
  libvlc_video_set_teletext: procedure( media_player : Plibvlc_media_player_t; i_page: Integer;  e: Plibvlc_exception_t  ); cdecl;

  (**
   * Get number of available video tracks.
   *
   * \param p_mi media player
   * \param p_e an initialized exception
   * \return the number of available video tracks (int)
   *)
    libvlc_video_get_track_count: function( media_player : Plibvlc_media_player_t;  e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get the description of available video tracks.
   *
   * \param p_mi media player
   * \param p_e an initialized exception
   * \return list with description of available video tracks
   *)

          libvlc_video_get_track_description: function( media_player : Plibvlc_media_player_t;  e: Plibvlc_exception_t  ):Plibvlc_track_description_t; cdecl;

  (**
   * Get current video track.
   *
   * \param p_mi media player
   * \param p_e an initialized exception pointer
   * \return the video track (int)
   *)
    libvlc_video_get_track: function( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Set video track.
   *
   * \param p_mi media player
   * \param i_track the track (int)
   * \param p_e an initialized exception pointer
   *)
   libvlc_video_set_track: procedure( media_player : Plibvlc_media_player_t; i_track: Integer;  e: Plibvlc_exception_t  ); cdecl;

  (**
   * Take a snapshot of the current video window.
   *
   * If i_width AND i_height is 0, original size is used.
   * If i_width XOR i_height is 0, original aspect-ratio is preserved.
   *
   * \param p_mi media player instance
   * \param psz_filepath the path where to save the screenshot to
   * \param i_width the snapshot's width
   * \param i_height the snapshot's height
   * \param p_e an initialized exception pointer
   *)
  libvlc_video_take_snapshot: procedure( media_player : Plibvlc_media_player_t;
                                         psz_filepath: PansiChar;
                                         i_width: Cardinal;
                                         i_height: Cardinal;
                                         e: Plibvlc_exception_t  ); cdecl;

  (**
   * Enable or disable deinterlace filter
   *
   * \param p_mi libvlc media player
   * \param b_enable boolean to enable or disable deinterlace filter
   * \param psz_mode type of deinterlace filter to use
   * \param p_e an initialized exception pointer
   *)
  libvlc_video_set_deinterlace: procedure( media_player : Plibvlc_media_player_t;
                                           b_enable: Integer;
                                           psz_mode: PansiChar;
                                           e: Plibvlc_exception_t ); cdecl;

  (**
   * Get an option value (option which return an int)
   *
   * \param p_mi libvlc media player
   * \param option marq option to get
   * \param p_e an initialized exception pointer
   *)
  libvlc_video_get_marquee_option_as_int: function( media_player : Plibvlc_media_player_t;
                                                          option: libvlc_video_marquee_int_option_t;
                                                          e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get an option value (option which return a string)
   *
   * \param p_mi libvlc media player
   * \param option marq option to get
   * \param p_e an initialized exception pointer
   *)
  libvlc_video_get_marquee_option_as_string: function( media_player : Plibvlc_media_player_t;
                                                               option: libvlc_video_marquee_string_option_t;
                                                               e: Plibvlc_exception_t  ):PansiChar; cdecl;

  (**
   * Enable, disable or set a marq option (only int)
   *
   * \param p_mi libvlc media player
   * \param option marq option to set
   * \param i_val marq option value
   * \param p_e an initialized exception pointer
   *)
  libvlc_video_set_marquee_option_as_int: procedure( media_player : Plibvlc_media_player_t;
                                                           option : libvlc_video_marquee_int_option_t;
                                                           i_val: Integer;
                                                           e: Plibvlc_exception_t  ); cdecl;

  (**
   * Set a marq option (only string)
   *
   * \param p_mi libvlc media player
   * \param option marq option to set
   * \param psz_text marq option value
   * \param p_e an initialized exception pointer
   *)
  libvlc_video_set_marquee_option_as_string: procedure( media_player : Plibvlc_media_player_t;
                                                              option: libvlc_video_marquee_string_option_t;
                                                              psz_text: PansiChar;
                                                              e: Plibvlc_exception_t  ); cdecl;

  (** @} video *)

  (** \defgroup libvlc_audio libvlc_audio
   * \ingroup libvlc_media_player
   * LibVLC Audio handling
   * @{
   *)

  (**
   * Audio device types
   *)
type
  libvlc_audio_output_device_types_t = (
      libvlc_AudioOutputDevice_Error  = -1,
      libvlc_AudioOutputDevice_Mono   =  1,
      libvlc_AudioOutputDevice_Stereo =  2,
      libvlc_AudioOutputDevice_2F2R   =  4,
      libvlc_AudioOutputDevice_3F2R   =  5,
      libvlc_AudioOutputDevice_5_1    =  6,
      libvlc_AudioOutputDevice_6_1    =  7,
      libvlc_AudioOutputDevice_7_1    =  8,
      libvlc_AudioOutputDevice_SPDIF  = 10
  ); // libvlc_audio_output_device_types_t;

  (**
   * Audio channels
   *)
  libvlc_audio_output_channel_t = (
      libvlc_AudioChannel_Error   = -1,
      libvlc_AudioChannel_Stereo  =  1,
      libvlc_AudioChannel_RStereo =  2,
      libvlc_AudioChannel_Left    =  3,
      libvlc_AudioChannel_Right   =  4,
      libvlc_AudioChannel_Dolbys  =  5
  );// libvlc_audio_output_channel_t;


var
  (**
   * Get the list of available audio outputs
   *
   * \param p_instance libvlc instance
   * \param p_e an initialized exception pointer
   * \return list of available audio outputs, at the end free it with
   *          \see libvlc_audio_output_list_release \see libvlc_audio_output_t
   *)
  libvlc_audio_output_list_get: function( Instance : Plibvlc_instance_t;
                                        e: Plibvlc_exception_t  ):Plibvlc_audio_output_t; cdecl;

  (**
   * Free the list of available audio outputs
   *
   * \param p_list list with audio outputs for release
   *)
  libvlc_audio_output_list_release: procedure ( p_list: Plibvlc_audio_output_t); cdecl;

  (**
   * Set the audio output.
   * Change will be applied after stop and play.
   *
   * \param p_instance libvlc instance
   * \param psz_name name of audio output,
   *               use psz_name of \see libvlc_audio_output_t
   * \return true if function succeded
   *)
  libvlc_audio_output_set: function( Instance : Plibvlc_instance_t;
                                              psz_name: PansiChar):integer; cdecl;

  (**
   * Get count of devices for audio output, these devices are hardware oriented
   * like analor or digital output of sound card
   *
   * \param p_instance libvlc instance
   * \param psz_audio_output - name of audio output, \see libvlc_audio_output_t
   * \return number of devices
   *)
  libvlc_audio_output_device_count: function( Instance : Plibvlc_instance_t;
                                              psz_audio_output: PansiChar):integer; cdecl;

  (**
   * Get long name of device, if not available short name given
   *
   * \param p_instance libvlc instance
   * \param psz_audio_output - name of audio output, \see libvlc_audio_output_t
   * \param i_device device index
   * \return long name of device
   *)
  libvlc_audio_output_device_longname: function( Instance : Plibvlc_instance_t;
                                                             psz_audio_output: PansiChar;
                                                             i_device: Integer):PansiChar; cdecl;

  (**
   * Get id name of device
   *
   * \param p_instance libvlc instance
   * \param psz_audio_output - name of audio output, \see libvlc_audio_output_t
   * \param i_device device index
   * \return id name of device, use for setting device, need to be free after use
   *)
  libvlc_audio_output_device_id: function( Instance : Plibvlc_instance_t;
                                                       psz_audio_output: PansiChar;
                                                       i_device: Integer):PansiChar; cdecl;

  (**
   * Set device for using
   *
   * \param p_instance libvlc instance
   * \param psz_audio_output - name of audio output, \see libvlc_audio_output_t
   * \param psz_device_id device
   *)
   libvlc_audio_output_device_set: procedure( Instance : Plibvlc_instance_t;
                                        psz_audio_output: PansiChar;
                                        psz_device_id: PansiChar); cdecl;

  (**
   * Get current audio device type. Device type describes something like
   * character of output sound - stereo sound, 2.1, 5.1 etc
   *
   * \param p_instance vlc instance
   * \param p_e an initialized exception pointer
   * \return the audio devices type \see libvlc_audio_output_device_types_t
   *)
  libvlc_audio_output_get_device_type: function(
          Instance : Plibvlc_instance_t; e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Set current audio device type.
   *
   * \param p_instance vlc instance
   * \param device_type the audio device type,
            according to \see libvlc_audio_output_device_types_t
   * \param p_e an initialized exception pointer
   *)
  libvlc_audio_output_set_device_type: procedure( Instance : Plibvlc_instance_t;
                                                           device_type: Integer;
                                                           e: Plibvlc_exception_t  ); cdecl;


  (**
   * Toggle mute status.
   *
   * \param p_instance libvlc instance
   *)
  libvlc_audio_toggle_mute: procedure( instance: Plibvlc_instance_t); cdecl;

  (**
   * Get current mute status.
   *
   * \param p_instance libvlc instance
   * \return the mute status (boolean)
   *)
  libvlc_audio_get_mute: function( instance: Plibvlc_instance_t):longbool; cdecl;

  (**
   * Set mute status.
   *
   * \param p_instance libvlc instance
   * \param status If status is true then mute, otherwise unmute
   *)
  libvlc_audio_set_mute: procedure( Instance : Plibvlc_instance_t; status: longbool); cdecl;

  (**
   * Get current audio level.
   *
   * \param p_instance libvlc instance
   * \param p_e an initialized exception pointer
   * \return the audio level (int)
   *)
  libvlc_audio_get_volume: function( instance: Plibvlc_instance_t):integer; cdecl;

  (**
   * Set current audio level.
   *
   * \param p_instance libvlc instance
   * \param i_volume the volume (int)
   * \param p_e an initialized exception pointer
   *)
  libvlc_audio_set_volume: procedure( Instance : Plibvlc_instance_t; i_volume: Integer;  e: Plibvlc_exception_t ); cdecl;

  (**
   * Get number of available audio tracks.
   *
   * \param p_mi media player
   * \param p_e an initialized exception
   * \return the number of available audio tracks (int)
   *)
  libvlc_audio_get_track_count: function( media_player : Plibvlc_media_player_t;  e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get the description of available audio tracks.
   *
   * \param p_mi media player
   * \param p_e an initialized exception
   * \return list with description of available audio tracks
   *)
  libvlc_audio_get_track_description: function( media_player : Plibvlc_media_player_t;  e: Plibvlc_exception_t  ):Plibvlc_track_description_t; cdecl;

  (**
   * Get current audio track.
   *
   * \param p_mi media player
   * \param p_e an initialized exception pointer
   * \return the audio track (int)
   *)
   libvlc_audio_get_track: function ( media_player : Plibvlc_media_player_t; e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Set current audio track.
   *
   * \param p_mi media player
   * \param i_track the track (int)
   * \param p_e an initialized exception pointer
   *)
  libvlc_audio_set_track: procedure( media_player : Plibvlc_media_player_t; int, e: Plibvlc_exception_t  ); cdecl;

  (**
   * Get current audio channel.
   *
   * \param p_instance vlc instance
   * \param p_e an initialized exception pointer
   * \return the audio channel \see libvlc_audio_output_channel_t
   *)
  libvlc_audio_get_channel: function( Instance : Plibvlc_instance_t; e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Set current audio channel.
   *
   * \param p_instance vlc instance
   * \param channel the audio channel, \see libvlc_audio_output_channel_t
   * \param p_e an initialized exception pointer
   *)
  libvlc_audio_set_channel: procedure( Instance : Plibvlc_instance_t;
                                                channel: Integer;
                                                e: Plibvlc_exception_t  ); cdecl;

  (** @} audio *)

  (** @} media_player *)
  (*****************************************************************************
   * Media List
   *****************************************************************************)
  (** \defgroup libvlc_media_list libvlc_media_list
   * \ingroup libvlc
   * LibVLC Media List, a media list holds multiple media descriptors
   * @{
   *)

  (**
   * Create an empty media list.
   *
   * \param p_libvlc libvlc instance
   * \param p_e an initialized exception pointer
   * \return empty media list
   *)
  libvlc_media_list_new: function ( Instance : Plibvlc_instance_t; e: Plibvlc_exception_t  ):Plibvlc_media_list_t; cdecl;

  (**
   * Release media list created with libvlc_media_list_new().
   *
   * \param p_ml a media list created with libvlc_media_list_new()
   *)
  libvlc_media_list_release: procedure( p_ml: Plibvlc_media_list_t); cdecl;

  (**
   * Retain reference to a media list
   *
   * \param p_ml a media list created with libvlc_media_list_new()
   *)
  libvlc_media_list_retain: procedure ( p_ml: Plibvlc_media_list_t); cdecl;

  //VLC_DEPRECATED_API
  libvlc_media_list_add_file_content: procedure ( p_mlist: Plibvlc_media_list_t;
                                          psz_uri: PansiChar ;
                                          p_e: Plibvlc_exception_t); cdecl;

  (**
   * Associate media instance with this media list instance.
   * If another media instance was present it will be released.
   * The libvlc_media_list_lock should NOT be held upon entering this function.
   *
   * \param p_ml a media list instance
   * \param p_mi media instance to add
   * \param p_e initialized exception object
   *)
  libvlc_media_list_set_media: procedure( medialist: Plibvlc_media_list_t;
                                              media: Plibvlc_media_t;
                                              e: Plibvlc_exception_t ); cdecl;

  (**
   * Get media instance from this media list instance. This action will increase
   * the refcount on the media instance.
   * The libvlc_media_list_lock should NOT be held upon entering this function.
   *
   * \param p_ml a media list instance
   * \param p_e initialized exception object
   * \return media instance
   *)
  libvlc_media_list_media: function ( medialist: Plibvlc_media_list_t;
                                          e: Plibvlc_exception_t ):Plibvlc_media_t; cdecl;

  (**
   * Add media instance to media list
   * The libvlc_media_list_lock should be held upon entering this function.
   *
   * \param p_ml a media list instance
   * \param p_mi a media instance
   * \param p_e initialized exception object
   *)
  libvlc_media_list_add_media: procedure ( medialist: Plibvlc_media_list_t;
                                              media: Plibvlc_media_t;
                                              e: Plibvlc_exception_t  ); cdecl;

  (**
   * Insert media instance in media list on a position
   * The libvlc_media_list_lock should be held upon entering this function.
   *
   * \param p_ml a media list instance
   * \param p_mi a media instance
   * \param i_pos position in array where to insert
   * \param p_e initialized exception object
   *)
  libvlc_media_list_insert_media: procedure( medialist: Plibvlc_media_list_t;
                                                 media: Plibvlc_media_t;
                                                 i_pos: Integer;
                                                 e: Plibvlc_exception_t  ); cdecl;
  (**
   * Remove media instance from media list on a position
   * The libvlc_media_list_lock should be held upon entering this function.
   *
   * \param p_ml a media list instance
   * \param i_pos position in array where to insert
   * \param p_e initialized exception object
   *)
  libvlc_media_list_remove_index: procedure( medialist: Plibvlc_media_list_t; i_pos: Integer;
                                      e: Plibvlc_exception_t  ); cdecl;

  (**
   * Get count on media list items
   * The libvlc_media_list_lock should be held upon entering this function.
   *
   * \param p_ml a media list instance
   * \param p_e initialized exception object
   * \return number of items in media list
   *)
  libvlc_media_list_count: function( p_mlist: Plibvlc_media_list_t;
                               p_e: Plibvlc_exception_t):integer; cdecl;

  (**
   * List media instance in media list at a position
   * The libvlc_media_list_lock should be held upon entering this function.
   *
   * \param p_ml a media list instance
   * \param i_pos position in array where to insert
   * \param p_e initialized exception object
   * \return media instance at position i_pos and libvlc_media_retain() has been called to increase the refcount on this object.
   *)
  libvlc_media_list_item_at_index: function( medialist: Plibvlc_media_list_t; i_pos: Integer;
                                       e: Plibvlc_exception_t  ):Plibvlc_media_t; cdecl;
  (**
   * Find index position of List media instance in media list.
   * Warning: the function will return the first matched position.
   * The libvlc_media_list_lock should be held upon entering this function.
   *
   * \param p_ml a media list instance
   * \param p_mi media list instance
   * \param p_e initialized exception object
   * \return position of media instance
   *)
  libvlc_media_list_index_of_item: function ( medialist: Plibvlc_media_list_t;
                                       media: Plibvlc_media_t;
                                       e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * This indicates if this media list is read-only from a user point of view
   *
   * \param p_ml media list instance
   * \return 0 on readonly, 1 on readwrite
   *)
  libvlc_media_list_is_readonly: function( p_mlist: Plibvlc_media_list_t):longbool; cdecl;

  (**
   * Get lock on media list items
   *
   * \param p_ml a media list instance
   *)
  libvlc_media_list_lock: procedure( p_ml: Plibvlc_media_list_t); cdecl;

  (**
   * Release lock on media list items
   * The libvlc_media_list_lock should be held upon entering this function.
   *
   * \param p_ml a media list instance
   *)
  libvlc_media_list_unlock: procedure( p_ml: Plibvlc_media_list_t); cdecl;

  (**
   * Get a flat media list view of media list items
   *
   * \param p_ml a media list instance
   * \param p_ex an excpetion instance
   * \return flat media list view instance
   *)
  libvlc_media_list_flat_view: function( medialist: Plibvlc_media_list_t;
                                   e: Plibvlc_exception_t  ):Plibvlc_media_list_view_t; cdecl;

  (**
   * Get a hierarchical media list view of media list items
   *
   * \param p_ml a media list instance
   * \param p_ex an exception instance
   * \return hierarchical media list view instance
   *)
  libvlc_media_list_hierarchical_view: function( medialist: Plibvlc_media_list_t;
                                           e: Plibvlc_exception_t  ):Plibvlc_media_list_view_t; cdecl;


  libvlc_media_list_hierarchical_node_view: function( p_ml: Plibvlc_media_list_t;
                                                p_ex: Plibvlc_exception_t):Plibvlc_media_list_view_t; cdecl;

  (**
   * Get libvlc_event_manager from this media list instance.
   * The p_event_manager is immutable, so you don't have to hold the lock
   *
   * \param p_ml a media list instance
   * \param p_ex an excpetion instance
   * \return libvlc_event_manager
   *)
  libvlc_media_list_event_manager: function( medialist: Plibvlc_media_list_t;
                                       e: Plibvlc_exception_t  ):Plibvlc_event_manager_t; cdecl;

  (** @} media_list *)
  (*****************************************************************************
   * Media List View
   *****************************************************************************)
  (** \defgroup libvlc_media_list_view libvlc_media_list_view
   * \ingroup libvlc
   * LibVLC Media List View: represents a media_list using a different layout.
   * The layout can be a flat one without hierarchy, a hierarchical one.
   *
   * Other type of layout, such as orderer media_list layout could be implemented
   * with this class.
   * @{ *)

  (**
   * Retain reference to a media list view
   *
   * \param p_mlv a media list view created with libvlc_media_list_view_new()
   *)
  libvlc_media_list_view_retain: procedure( p_mlv: Plibvlc_media_list_view_t); cdecl;

  (**
   * Release reference to a media list view. If the refcount reaches 0, then
   * the object will be released.
   *
   * \param p_mlv a media list view created with libvlc_media_list_view_new()
   *)
  libvlc_media_list_view_release: procedure( p_mlv: Plibvlc_media_list_view_t); cdecl;

  (**
   * Get libvlc_event_manager from this media list view instance.
   * The p_event_manager is immutable, so you don't have to hold the lock
   *
   * \param p_mlv a media list view instance
   * \return libvlc_event_manager
   *)
  libvlc_media_list_view_event_manager: function( p_mlv: Plibvlc_media_list_view_t):Plibvlc_event_manager_t; cdecl;

  (**
   * Get count on media list view items
   *
   * \param p_mlv a media list view instance
   * \param p_e initialized exception object
   * \return number of items in media list view
   *)
  libvlc_media_list_view_count: function(  p_mlv: Plibvlc_media_list_view_t;
                                     p_e: Plibvlc_exception_t):integer; cdecl;

  (**
   * List media instance in media list view at an index position
   *
   * \param p_mlv a media list view instance
   * \param i_index index position in array where to insert
   * \param p_e initialized exception object
   * \return media instance at position i_pos and libvlc_media_retain() has been called to increase the refcount on this object.
   *)

  libvlc_media_list_view_item_at_index: function(  p_mlv: Plibvlc_media_list_view_t;
                                             i_index: Integer;
                                             p_e: Plibvlc_exception_t):Plibvlc_media_t; cdecl;


  libvlc_media_list_view_children_at_index: function(  p_mlv: Plibvlc_media_list_view_t;
                                             index: Integer;
                                             p_e: Plibvlc_exception_t):Plibvlc_media_list_view_t; cdecl;


  libvlc_media_list_view_children_for_item: function(  p_mlv: Plibvlc_media_list_view_t;
                                             p_md: Plibvlc_media_t;
                                             p_e: Plibvlc_exception_t):Plibvlc_media_list_view_t; cdecl;


  libvlc_media_list_view_parent_media_list: function(  p_mlv: Plibvlc_media_list_view_t;
                                                 p_e: Plibvlc_exception_t):Plibvlc_media_list_t; cdecl;

  (** @} media_list_view *)
  (*****************************************************************************
   * Media List Player
   *****************************************************************************)
  (** \defgroup libvlc_media_list_player libvlc_media_list_player
   * \ingroup libvlc
   * LibVLC Media List Player, play a media_list. You can see that as a media
   * instance subclass
   * @{
   *)
type
  Plibvlc_media_list_player_t = ^libvlc_media_list_player_t;
  libvlc_media_list_player_t= record
  end; //libvlc_media_list_player_t ;

  (**
   *  Defines playback modes for playlist.
   *)
type
  libvlc_playback_mode_t = (libvlc_playback_mode_default,
      libvlc_playback_mode_loop,
      libvlc_playback_mode_repeat
  ); // libvlc_playback_mode_t;

var
  (**
   * Create new media_list_player.
   *
   * \param p_instance libvlc instance
   * \param p_e initialized exception instance
   * \return media list player instance
   *)
  libvlc_media_list_player_new: function( p_instance: Plibvlc_instance_t;
                                    p_e: Plibvlc_exception_t):Plibvlc_media_list_player_t; cdecl;

  (**
   * Release media_list_player.
   *
   * \param p_mlp media list player instance
   *)
  libvlc_media_list_player_release: procedure( p_mlp: Plibvlc_media_list_player_t); cdecl;

  (**
   * Return the event manager of this media_list_player.
   *
   * \param p_mlp media list player instance
   *)
  libvlc_media_list_player_event_manager: function(p_mlp: Plibvlc_media_list_player_t):Plibvlc_event_manager_t; cdecl;

  (**
   * Replace media player in media_list_player with this instance.
   *
   * \param p_mlp media list player instance
   * \param p_mi media player instance
   * \param p_e initialized exception instance
   *)
  libvlc_media_list_player_set_media_player: procedure(
                                       p_mlp: Plibvlc_media_list_player_t;
                                       p_mi: Plibvlc_media_player_t;
                                       p_e: Plibvlc_exception_t); cdecl;

  libvlc_media_list_player_set_media_list: procedure (
                                       p_mlp: Plibvlc_media_list_player_t;
                                       p_mlist: Plibvlc_media_list_t;
                                       p_e: Plibvlc_exception_t); cdecl;

  (**
   * Play media list
   *
   * \param p_mlp media list player instance
   * \param p_e initialized exception instance
   *)
  libvlc_media_list_player_play: procedure( p_mlp: Plibvlc_media_list_player_t;
                                     p_e: Plibvlc_exception_t); cdecl;

  (**
   * Pause media list
   *
   * \param p_mlp media list player instance
   * \param p_e initialized exception instance
   *)
  libvlc_media_list_player_pause: procedure( p_mlp: Plibvlc_media_list_player_t;
                                     p_e: Plibvlc_exception_t); cdecl;

  (**
   * Is media list playing?
   *
   * \param p_mlp media list player instance
   * \param p_e initialized exception instance
   * \return true for playing and false for not playing
   *)
  libvlc_media_list_player_is_playing: function( p_mlp: Plibvlc_media_list_player_t;
                                           p_e: Plibvlc_exception_t):integer; cdecl;

  (**
   * Get current libvlc_state of media list player
   *
   * \param p_mlp media list player instance
   * \param p_e initialized exception instance
   * \return libvlc_state_t for media list player
   *)
  libvlc_media_list_player_get_state: function( p_mlp: Plibvlc_media_list_player_t;
                                          p_e: Plibvlc_exception_t):libvlc_state_t; cdecl;

  (**
   * Play media list item at position index
   *
   * \param p_mlp media list player instance
   * \param i_index index in media list to play
   * \param p_e initialized exception instance
   *)
  libvlc_media_list_player_play_item_at_index: procedure(
                                     p_mlp: Plibvlc_media_list_player_t;
                                     i_index: Integer;
                                     p_e: Plibvlc_exception_t); cdecl;

  libvlc_media_list_player_play_item: procedure(
                                     p_mlp: Plibvlc_media_list_player_t;
                                     p_md: Plibvlc_media_t;
                                     p_e: Plibvlc_exception_t); cdecl;

  (**
   * Stop playing media list
   *
   * \param p_mlp media list player instance
   * \param p_e initialized exception instance
   *)
  libvlc_media_list_player_stop: procedure( p_mlp: Plibvlc_media_list_player_t;
                                     p_e: Plibvlc_exception_t); cdecl;

  (**
   * Play next item from media list
   *
   * \param p_mlp media list player instance
   * \param p_e initialized exception instance
   *)
  libvlc_media_list_player_next: procedure ( p_mlp: Plibvlc_media_list_player_t;
                                     p_e: Plibvlc_exception_t); cdecl;

  (**
   * Play previous item from media list
   *
   * \param p_mlp media list player instance
   * \param p_e initialized exception instance
   *)
  libvlc_media_list_player_previous: procedure ( p_mlp: Plibvlc_media_list_player_t;
                                         p_e: Plibvlc_exception_t); cdecl;



  (**
   * Sets the playback mode for the playlist
   *
   * \param p_mlp media list player instance
   * \param e_mode playback mode specification
   * \param p_e initialized exception instance
   *)
  libvlc_media_list_player_set_playback_mode: procedure (p_mlp: Plibvlc_media_list_player_t;
                                          e_mode: libvlc_playback_mode_t;
                                          p_e: Plibvlc_exception_t); cdecl;

  (** @} media_list_player *)
  (*****************************************************************************
   * Media Library
   *****************************************************************************)
  (** \defgroup libvlc_media_library libvlc_media_library
   * \ingroup libvlc
   * LibVLC Media Library
   * @{
   *)
type
  Plibvlc_media_library_t = ^libvlc_media_library_t;
  libvlc_media_library_t= record
  end; //libvlc_media_library_t ;

var
  (**
   * Create an new Media Library object
   *
   * \param p_libvlc_instance the libvlc instance
   * \param p_e an initialized exception pointer
   *)
  libvlc_media_library_new: function ( p_inst: Plibvlc_instance_t;
                                p_e: Plibvlc_exception_t):Plibvlc_media_library_t; cdecl;

  (**
   * Release media library object. This functions decrements the
   * reference count of the media library object. If it reaches 0,
   * then the object will be released.
   *
   * \param p_mlib media library object
   *)
  libvlc_media_library_release: procedure( p_mlib: Plibvlc_media_library_t); cdecl;

  (**
   * Retain a reference to a media library object. This function will
   * increment the reference counting for this object. Use
   * libvlc_media_library_release() to decrement the reference count.
   *
   * \param p_mlib media library object
   *)
  libvlc_media_library_retain: procedure( p_mlib: Plibvlc_media_library_t); cdecl;

  (**
   * Load media library.
   *
   * \param p_mlib media library object
   * \param p_e an initialized exception object.
   *)
  libvlc_media_library_load: procedure( p_mlib: Plibvlc_media_library_t;
                                 p_e: Plibvlc_exception_t); cdecl;

  (**
   * Save media library.
   *
   * \param p_mlib media library object
   * \param p_e an initialized exception object.
   *)
  libvlc_media_library_save: procedure( p_mlib: Plibvlc_media_library_t;
                                 p_e: Plibvlc_exception_t); cdecl;

  (**
   * Get media library subitems.
   *
   * \param p_mlib media library object
   * \param p_e an initialized exception object.
   * \return media list subitems
   *)
  libvlc_media_library_media_list: function( p_mlib: Plibvlc_media_library_t;
                                       p_e: Plibvlc_exception_t):Plibvlc_media_list_t; cdecl;


  (** @} *)
  (*****************************************************************************
   * Services/Media Discovery
   *****************************************************************************)
  (** \defgroup libvlc_media_discoverer libvlc_media_discoverer
   * \ingroup libvlc
   * LibVLC Media Discoverer
   * @{
   *)
type
  Plibvlc_media_discoverer_t = ^ libvlc_media_discoverer_t;
  libvlc_media_discoverer_t = record
  end; //libvlc_media_discoverer_t;

var
  (**
   * Discover media service by name.
   *
   * \param p_inst libvlc instance
   * \param psz_name service name
   * \param p_e an initialized exception object
   * \return media discover object
   *)

  libvlc_media_discoverer_new_from_name: function( p_inst: Plibvlc_instance_t;
                                         psz_name: PansiChar ;
                                         p_e: Plibvlc_exception_t):Plibvlc_media_discoverer_t; cdecl;

  (**
   * Release media discover object. If the reference count reaches 0, then
   * the object will be released.
   *
   * \param p_mdis media service discover object
   *)
  libvlc_media_discoverer_release: procedure( p_mdis: Plibvlc_media_discoverer_t); cdecl;

  (**
   * Get media service discover object its localized name.
   *
   * \param media discover object
   * \return localized name
   *)
  libvlc_media_discoverer_localized_name: function( p_mdis: Plibvlc_media_discoverer_t):PansiChar; cdecl;

  (**
   * Get media service discover media list.
   *
   * \param p_mdis media service discover object
   * \return list of media items
   *)
  libvlc_media_discoverer_media_list: function( p_mdis: Plibvlc_media_discoverer_t):Plibvlc_media_list_t; cdecl;

  (**
   * Get event manager from media service discover object.
   *
   * \param p_mdis media service discover object
   * \return event manager object.
   *)
  libvlc_media_discoverer_event_manager: function( p_mdis: Plibvlc_media_discoverer_t):Plibvlc_event_manager_t; cdecl;

  (**
   * Query if media service discover object is running.
   *
   * \param p_mdis media service discover object
   * \return true if running, false if not
   *)
  libvlc_media_discoverer_is_running: function( p_mdis: Plibvlc_media_discoverer_t):integer; cdecl;

  (**@} *)
  (*****************************************************************************
   * Events handling
   *****************************************************************************)

  (** \defgroup libvlc_event libvlc_event
   * \ingroup libvlc_core
   * LibVLC Available Events
   * @{
   *)

  (**@} *)
  (*****************************************************************************
   * VLM
   *****************************************************************************)
  (** \defgroup libvlc_vlm libvlc_vlm
   * \ingroup libvlc
   * LibVLC VLM
   * @{
   *)


  (**
   * Release the vlm instance related to the given libvlc_instance_t
   *
   * \param p_instance the instance
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_release: procedure( Instance : Plibvlc_instance_t; e: Plibvlc_exception_t  ); cdecl;

  (**
   * Add a broadcast, with one input.
   *
   * \param p_instance the instance
   * \param psz_name the name of the new broadcast
   * \param psz_input the input MRL
   * \param psz_output the output MRL (the parameter to the "sout" variable)
   * \param i_options number of additional options
   * \param ppsz_options additional options
   * \param b_enabled boolean for enabling the new broadcast
   * \param b_loop Should this broadcast be played in loop ?
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_add_broadcast: procedure( Instance : Plibvlc_instance_t;
                                       psz_name: PansiChar;
                                       psz_input: PansiChar;
                                       psz_output: PansiChar;
                                       i_options: Integer;
                                       ppsz_options: PPansiChar;
                                       b_enabled: Integer;
                                       b_loop: Integer;
                                       e: Plibvlc_exception_t  ); cdecl;

  (**
   * Add a vod, with one input.
   *
   * \param p_instance the instance
   * \param psz_name the name of the new vod media
   * \param psz_input the input MRL
   * \param i_options number of additional options
   * \param ppsz_options additional options
   * \param b_enabled boolean for enabling the new vod
   * \param psz_mux the muxer of the vod media
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_add_vod: procedure( Instance : Plibvlc_instance_t;
                                 psz_name: PansiChar;
                                 psz_input: PansiChar;
                                 i_options: Integer;
                                 ppsz_options: PPansiChar;
                                 b_enabled: Integer;
                                 psz_mux: PansiChar;
                                 e: Plibvlc_exception_t  ); cdecl;

  (**
   * Delete a media (VOD or broadcast).
   *
   * \param p_instance the instance
   * \param psz_name the media to delete
   * \param p_e an initialized exception pointer
   *)
   libvlc_vlm_del_media: procedure( Instance : Plibvlc_instance_t;
                                            psz_name: PansiChar;
                                            e: Plibvlc_exception_t  ); cdecl;

  (**
   * Enable or disable a media (VOD or broadcast).
   *
   * \param p_instance the instance
   * \param psz_name the media to work on
   * \param b_enabled the new status
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_set_enabled: procedure( Instance : Plibvlc_instance_t;
                                     psz_name: PansiChar;
                                     b_enabled: Integer;
                                     e: Plibvlc_exception_t  ); cdecl;

  (**
   * Set the output for a media.
   *
   * \param p_instance the instance
   * \param psz_name the media to work on
   * \param psz_output the output MRL (the parameter to the "sout" variable)
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_set_output: procedure( Instance : Plibvlc_instance_t;
                                    psz_name: PansiChar;
                                    psz_output: PansiChar;
                                    e: Plibvlc_exception_t  ); cdecl;

  (**
   * Set a media's input MRL. This will delete all existing inputs and
   * add the specified one.
   *
   * \param p_instance the instance
   * \param psz_name the media to work on
   * \param psz_input the input MRL
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_set_input: procedure( Instance : Plibvlc_instance_t;
                                   psz_name: PansiChar;
                                   psz_input: PansiChar;
                                   e: Plibvlc_exception_t  ); cdecl;

  (**
   * Add a media's input MRL. This will add the specified one.
   *
   * \param p_instance the instance
   * \param psz_name the media to work on
   * \param psz_input the input MRL
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_add_input: procedure( Instance : Plibvlc_instance_t;
                                   psz_name: PansiChar;
                                   psz_input: PansiChar;
                                   e: Plibvlc_exception_t  ); cdecl;
  (**
   * Set a media's loop status.
   *
   * \param p_instance the instance
   * \param psz_name the media to work on
   * \param b_loop the new status
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_set_loop: procedure( Instance : Plibvlc_instance_t;
                                  psz_name: PansiChar;
                                  b_loop: Integer;
                                  e: Plibvlc_exception_t  ); cdecl;

  (**
   * Set a media's vod muxer.
   *
   * \param p_instance the instance
   * \param psz_name the media to work on
   * \param psz_mux the new muxer
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_set_mux: procedure( Instance : Plibvlc_instance_t;
                                 psz_name: PansiChar;
                                 psz_mux: PansiChar;
                                 e: Plibvlc_exception_t  ); cdecl;

  (**
   * Edit the parameters of a media. This will delete all existing inputs and
   * add the specified one.
   *
   * \param p_instance the instance
   * \param psz_name the name of the new broadcast
   * \param psz_input the input MRL
   * \param psz_output the output MRL (the parameter to the "sout" variable)
   * \param i_options number of additional options
   * \param ppsz_options additional options
   * \param b_enabled boolean for enabling the new broadcast
   * \param b_loop Should this broadcast be played in loop ?
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_change_media: procedure( Instance : Plibvlc_instance_t;
                                               psz_name: PansiChar;
                                               psz_input: PansiChar;
                                               psz_output: PAnsiChar;
                                               i_options: Integer;
                                               ppsz_options: PPAnsiChar;
                                               b_enabled: Integer;
                                               b_loop: Integer;
                                               e: Plibvlc_exception_t  ); cdecl;

  (**
   * Play the named broadcast.
   *
   * \param p_instance the instance
   * \param psz_name the name of the broadcast
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_play_media: procedure ( Instance : Plibvlc_instance_t; psz_name: PansiChar;
                                              e: Plibvlc_exception_t  ); cdecl;

  (**
   * Stop the named broadcast.
   *
   * \param p_instance the instance
   * \param psz_name the name of the broadcast
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_stop_media : procedure( Instance : Plibvlc_instance_t; psz_name: PansiChar;
                                              e: Plibvlc_exception_t  ); cdecl;

  (**
   * Pause the named broadcast.
   *
   * \param p_instance the instance
   * \param psz_name the name of the broadcast
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_pause_media: procedure( Instance : Plibvlc_instance_t; psz_name: PansiChar;
                                              e: Plibvlc_exception_t  ); cdecl;

  (**
   * Seek in the named broadcast.
   *
   * \param p_instance the instance
   * \param psz_name the name of the broadcast
   * \param f_percentage the percentage to seek to
   * \param p_e an initialized exception pointer
   *)
  libvlc_vlm_seek_media: procedure( Instance : Plibvlc_instance_t; const psz_name: PansiChar;
                                             f_percentage: Single;  e: Plibvlc_exception_t  ); cdecl;

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
   * \param p_instance the instance
   * \param psz_name the name of the media,
   *      if the name is an empty string, all media is described
   * \param p_e an initialized exception pointer
   * \return string with information about named media
   *)
  libvlc_vlm_show_media: function ( Instance : Plibvlc_instance_t; psz_name: PansiChar;
                                              e: Plibvlc_exception_t  ):PAnsichar; cdecl;

  (**
   * Get vlm_media instance position by name or instance id
   *
   * \param p_instance a libvlc instance
   * \param psz_name name of vlm media instance
   * \param i_instance instance id
   * \param p_e an initialized exception pointer
   * \return position as float
   *)
  libvlc_vlm_get_media_instance_position: function ( Instance : Plibvlc_instance_t;
                                                               psz_name: PansiChar;  i_instance: Integer;
                                                               e: Plibvlc_exception_t  ):single; cdecl;

  (**
   * Get vlm_media instance time by name or instance id
   *
   * \param p_instance a libvlc instance
   * \param psz_name name of vlm media instance
   * \param i_instance instance id
   * \param p_e an initialized exception pointer
   * \return time as integer
   *)
  libvlc_vlm_get_media_instance_time: function( Instance : Plibvlc_instance_t;
                                                         psz_name: PansiChar;  i_instance: Integer;
                                                         e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get vlm_media instance length by name or instance id
   *
   * \param p_instance a libvlc instance
   * \param psz_name name of vlm media instance
   * \param i_instance instance id
   * \param p_e an initialized exception pointer
   * \return length of media item
   *)
  libvlc_vlm_get_media_instance_length: function( Instance : Plibvlc_instance_t;
                                                           psz_name: PansiChar;  i_instance: Integer;
                                                           e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get vlm_media instance playback rate by name or instance id
   *
   * \param p_instance a libvlc instance
   * \param psz_name name of vlm media instance
   * \param i_instance instance id
   * \param p_e an initialized exception pointer
   * \return playback rate
   *)
  libvlc_vlm_get_media_instance_rate: function( Instance : Plibvlc_instance_t;
                                                         psz_name: PansiChar;  i_instance: Integer;
                                                         e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get vlm_media instance title number by name or instance id
   * \bug will always return 0
   * \param p_instance a libvlc instance
   * \param psz_name name of vlm media instance
   * \param i_instance instance id
   * \param p_e an initialized exception pointer
   * \return title as number
   *)
  libvlc_vlm_get_media_instance_title: function( Instance : Plibvlc_instance_t;
                                                          psz_name: PansiChar;  i_instance: Integer;
                                                          e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get vlm_media instance chapter number by name or instance id
   * \bug will always return 0
   * \param p_instance a libvlc instance
   * \param psz_name name of vlm media instance
   * \param i_instance instance id
   * \param p_e an initialized exception pointer
   * \return chapter as number
   *)
  libvlc_vlm_get_media_instance_chapter: function ( Instance : Plibvlc_instance_t;
                                                            psz_name: PansiChar;  i_instance: Integer;
                                                            e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Is libvlc instance seekable ?
   * \bug will always return 0
   * \param p_instance a libvlc instance
   * \param psz_name name of vlm media instance
   * \param i_instance instance id
   * \param p_e an initialized exception pointer
   * \return 1 if seekable, 0 if not
   *)
  libvlc_vlm_get_media_instance_seekable: function( Instance : Plibvlc_instance_t;
                                                             psz_name: PansiChar;  i_instance: Integer;
                                                             e: Plibvlc_exception_t  ):integer; cdecl;

  (**
   * Get libvlc_event_manager from a vlm media.
   * The p_event_manager is immutable, so you don't have to hold the lock
   *
   * \param p_instance a libvlc instance
   * \param p_exception an initialized exception pointer
   * \return libvlc_event_manager
   *)
  libvlc_vlm_get_event_manager: function( Instance : Plibvlc_instance_t;
                                          e: Plibvlc_exception_t  ):Plibvlc_event_manager_t; cdecl;

  (** @} *)


Type
  (**
   * mediacontrol_Instance is an opaque structure, defined in
   * mediacontrol_internal.h. API users do not have to mess with it.
   *)
  mediacontrol_Instance = record
  end;
  Pmediacontrol_Instance = ^mediacontrol_Instance;

  (**
   * A position may have different origins:
   *  - absolute counts from the movie start
   *  - relative counts from the current position
   *  - modulo counts from the current position and wraps at the end of the movie
   *)
  mediacontrol_PositionOrigin =( mediacontrol_AbsolutePosition,
                                 mediacontrol_RelativePosition,
                                 mediacontrol_ModuloPosition);

  (**
   * Units available in mediacontrol Positions
   *  - ByteCount number of bytes
   *  - SampleCount number of frames
   *  - MediaTime time in milliseconds
   *)
  mediacontrol_PositionKey = ( mediacontrol_ByteCount,
                               mediacontrol_SampleCount,
                               mediacontrol_MediaTime);

  (**
   * Possible player status
   * Note the order of these enums must match exactly the order of
   * libvlc_state_t and input_state_e enums.
   *)
  mediacontrol_PlayerStatus = (mediacontrol_UndefinedStatus=0, mediacontrol_InitStatus,
                            mediacontrol_BufferingStatus, mediacontrol_PlayingStatus,
                            mediacontrol_PauseStatus,     mediacontrol_StopStatus,
                            mediacontrol_EndStatus,       mediacontrol_ErrorStatus);

  (**
   * MediaControl Position
   *)
  Pmediacontrol_Position = ^mediacontrol_Position;
  mediacontrol_Position = packed record
    origin: mediacontrol_PositionOrigin;
    key: mediacontrol_PositionKey;
    value: int64;
  end;

  (**
   * RGBPicture structure
   * This generic structure holds a picture in an encoding specified by type.
   *)
  Pmediacontrol_RGBPicture = ^mediacontrol_RGBPicture;
  mediacontrol_RGBPicture = packed record
    width: Integer;
    height: Integer;
    _type: uint32;
    date: int64;
    size: Integer;
    data: PAnsiChar;
  end;

  (**
   * Playlist sequence
   * A simple list of strings.
   *)
  Pmediacontrol_PlaylistSeq = ^mediacontrol_PlaylistSeq;
  mediacontrol_PlaylistSeq = packed record
    size: Integer;
    data: PPChar;
  end;

  Pmediacontrol_Exception =^mediacontrol_Exception;
  mediacontrol_Exception = packed record
    code: Integer;
    message: PChar;
  end;

  (**
   * Exception codes
   *)
Const
  mediacontrol_PositionKeyNotSupported   = 1;
  mediacontrol_PositionOriginNotSupported= 2;
  mediacontrol_InvalidPosition           = 3;
  mediacontrol_PlaylistException         = 4;
  mediacontrol_InternalException         = 5;

type
  (**
   * Stream information
   * This structure allows to quickly get various informations about the stream.
   *)
  Pmediacontrol_StreamInformation = ^mediacontrol_StreamInformation;
  mediacontrol_StreamInformation = packed record
      streamstatus: mediacontrol_PlayerStatus;
      url: PChar;          (* The URL of the current media stream *)
      position: int64;   (* actual location in the stream (in ms) *)
      length: int64;     (* total length of the stream (in ms) *)
  end;



  (**************************************************************************
   *  Helper functions
   ***************************************************************************)
var
  (**
   * Free a RGBPicture structure.
   * \param pic: the RGBPicture structure
   *)
  mediacontrol_RGBPicture__free: procedure( pic: Pmediacontrol_RGBPicture); cdecl;

  mediacontrol_PlaylistSeq__free: procedure ( ps: Pmediacontrol_PlaylistSeq); cdecl;

  (**
   * Free a StreamInformation structure.
   * \param pic: the StreamInformation structure
   *)
  mediacontrol_StreamInformation__free : Procedure( p_si: Pmediacontrol_StreamInformation); cdecl;

  (**
   * Instanciate and initialize an exception structure.
   * \return the exception
   *)
  mediacontrol_exception_create : function :Pmediacontrol_Exception; cdecl;

  (**
   * Initialize an existing exception structure.
   * \param p_exception the exception to initialize.
   *)
  mediacontrol_exception_init: procedure( exception: Pmediacontrol_Exception); cdecl;

  (**
   * Clean up an existing exception structure after use.
   * \param p_exception the exception to clean up.
   *)
  mediacontrol_exception_cleanup: procedure( exception: Pmediacontrol_Exception); cdecl;

  (**
   * Free an exception structure created with mediacontrol_exception_create().
   * \return the exception
   *)
  mediacontrol_exception_free: procedure (exception: Pmediacontrol_Exception); cdecl;

  (*****************************************************************************
   * Core functions
   *****************************************************************************)

  (**
   * Create a MediaControl instance with parameters
   * \param argc the number of arguments
   * \param argv parameters
   * \param exception an initialized exception pointer
   * \return a mediacontrol_Instance
   *)

  mediacontrol_new : function ( argc: Integer;
                                argv: PPChar;
                                exception: Pmediacontrol_Exception):Pmediacontrol_Instance; cdecl;

  (**
   * Create a MediaControl instance from an existing libvlc instance
   * \param p_instance the libvlc instance
   * \param exception an initialized exception pointer
   * \return a mediacontrol_Instance
   *)
  mediacontrol_new_from_instance: function ( p_instance: Plibvlc_instance_t;
                  exception: Pmediacontrol_Exception):Pmediacontrol_Instance; cdecl;

  (**
   * Get the associated libvlc instance
   * \param self: the mediacontrol instance
   * \return a libvlc instance
   *)
  mediacontrol_get_libvlc_instance : function ( self: Pmediacontrol_Instance):Plibvlc_instance_t; cdecl;

  (**
   * Get the associated libvlc_media_player
   * \param self: the mediacontrol instance
   * \return a libvlc_media_player_t instance
   *)
  mediacontrol_get_media_player: function( self: Pmediacontrol_Instance):Plibvlc_media_player_t; cdecl;

  (**
   * Get the current position
   * \param self the mediacontrol instance
   * \param an_origin the position origin
   * \param a_key the position unit
   * \param exception an initialized exception pointer
   * \return a mediacontrol_Position
   *)
  mediacontrol_get_media_position: function( self: Pmediacontrol_Instance;
                           an_origin: mediacontrol_PositionOrigin;
                           a_key: mediacontrol_PositionKey;
                           exception: Pmediacontrol_Exception):Pmediacontrol_Position; cdecl;

  (**
   * Set the position
   * \param self the mediacontrol instance
   * \param a_position a mediacontrol_Position
   * \param exception an initialized exception pointer
   *)
  mediacontrol_set_media_position: procedure( self: Pmediacontrol_Instance;
                                        a_position: Pmediacontrol_Position;
                                        exception: Pmediacontrol_Exception); cdecl;

  (**
   * Play the movie at a given position
   * \param self the mediacontrol instance
   * \param a_position a mediacontrol_Position
   * \param exception an initialized exception pointer
   *)
  mediacontrol_start: procedure ( self: Pmediacontrol_Instance;
                           a_position: Pmediacontrol_Position;
                           exception: Pmediacontrol_Exception); cdecl;

  (**
   * Pause the movie at a given position
   * \param self the mediacontrol instance
   * \param exception an initialized exception pointer
   *)
  mediacontrol_pause: procedure( self: Pmediacontrol_Instance;
                           exception: Pmediacontrol_Exception); cdecl;

  (**
   * Resume the movie at a given position
   * \param self the mediacontrol instance
   * \param exception an initialized exception pointer
   *)
  mediacontrol_resume: procedure( self: Pmediacontrol_Instance;
                            exception: Pmediacontrol_Exception); cdecl;

  (**
   * Stop the movie at a given position
   * \param self the mediacontrol instance
   * \param exception an initialized exception pointer
   *)
  mediacontrol_stop: procedure ( self: Pmediacontrol_Instance;
                          exception: Pmediacontrol_Exception); cdecl;

  (**
   * Exit the player
   * \param self the mediacontrol instance
   *)
  mediacontrol_exit: procedure ( self: Pmediacontrol_Instance); cdecl;

  (**
   * Set the MRL to be played.
   * \param self the mediacontrol instance
   * \param psz_file the MRL
   * \param exception an initialized exception pointer
   *)
  mediacontrol_set_mrl: procedure( self: Pmediacontrol_Instance;
                                       psz_file: PAnsiChar;
                                       exception: Pmediacontrol_Exception); cdecl;

  (**
   * Get the MRL to be played.
   * \param self the mediacontrol instance
   * \param exception an initialized exception pointer
   *)
   mediacontrol_get_mrl: function( self: Pmediacontrol_Instance;
                                   exception: Pmediacontrol_Exception):PAnsichar; cdecl;

  (*****************************************************************************
   * A/V functions
   *****************************************************************************)
  (**
   * Get a snapshot
   * \param self the mediacontrol instance
   * \param a_position the desired position (ignored for now)
   * \param exception an initialized exception pointer
   * \return a RGBpicture
   *)
  mediacontrol_snapshot: function( self: Pmediacontrol_Instance;
                           a_position: Pmediacontrol_Position;
                           exception: Pmediacontrol_Exception):Pmediacontrol_RGBPicture; cdecl;

  (**
   *  Displays the message string, between "begin" and "end" positions.
   * \param self the mediacontrol instance
   * \param message the message to display
   * \param begin the begin position
   * \param end the end position
   * \param exception an initialized exception pointer
   *)
  mediacontrol_display_text: procedure( self: Pmediacontrol_Instance;
                                  message: PAnsiChar;
                                  _begin: Pmediacontrol_Position;
                                  _end: Pmediacontrol_Position;
                                  exception: Pmediacontrol_Exception); cdecl;

  (**
   *  Get information about a stream
   * \param self the mediacontrol instance
   * \param a_key the time unit
   * \param exception an initialized exception pointer
   * \return a mediacontrol_StreamInformation
   *)
  mediacontrol_get_stream_information: function( self: Pmediacontrol_Instance;
                                         a_key: mediacontrol_PositionKey;
                                         exception: Pmediacontrol_Exception):Pmediacontrol_StreamInformation; cdecl;

  (**
   * Get the current audio level, normalized in [0..100]
   * \param self the mediacontrol instance
   * \param exception an initialized exception pointer
   * \return the volume
   *)
  mediacontrol_sound_get_volume: function( self: Pmediacontrol_Instance;
                                   exception: Pmediacontrol_Exception):Word; cdecl;
  (**
   * Set the audio level
   * \param self the mediacontrol instance
   * \param volume the volume (normalized in [0..100])
   * \param exception an initialized exception pointer
   *)
  mediacontrol_sound_set_volume: procedure( self: Pmediacontrol_Instance;
                                      volume: Word;
                                      exception: Pmediacontrol_Exception); cdecl;

  (**
   * Set the video output window
   * \param self the mediacontrol instance
   * \param visual_id the Xid or HWND, depending on the platform
   * \param exception an initialized exception pointer
   *)
  mediacontrol_set_visual: function( self: Pmediacontrol_Instance;
                                      visual_id: THANDLE;
                                      exception: Pmediacontrol_Exception):integer; cdecl;

  (**
   * Get the current playing rate, in percent
   * \param self the mediacontrol instance
   * \param exception an initialized exception pointer
   * \return the rate
   *)
   mediacontrol_get_rate: function( self: Pmediacontrol_Instance;
                 exception: Pmediacontrol_Exception):integer; cdecl;

  (**
   * Set the playing rate, in percent
   * \param self the mediacontrol instance
   * \param rate the desired rate
   * \param exception an initialized exception pointer
   *)
  mediacontrol_set_rate : Procedure( self: Pmediacontrol_Instance;
                  rate: Integer;
                  exception: Pmediacontrol_Exception); cdecl;

  (**
   * Get current fullscreen status
   * \param self the mediacontrol instance
   * \param exception an initialized exception pointer
   * \return the fullscreen status
   *)
  mediacontrol_get_fullscreen: function( self: Pmediacontrol_Instance;
                   exception: Pmediacontrol_Exception):integer; cdecl;

  (**
   * Set fullscreen status
   * \param self the mediacontrol instance
   * \param b_fullscreen the desired status
   * \param exception an initialized exception pointer
   *)
  mediacontrol_set_fullscreen: procedure( self: Pmediacontrol_Instance;
                    b_fullscreen: longbool;
                    exception: Pmediacontrol_Exception); cdecl;


{$ENDREGION}

const
  VLD_SUCCESS  =  1;
  VLD_NOLIB    = -1;
  VLD_NOTFOUND = -2;

  // load libvlc.dll (get Install path from registry)
  function VLCLoadLibrary:longbool;

  procedure VLCUnloadLibrary;
  // return Install path found in registry by VLD_LoadLibrary
  function VLCLibPath:string;
  // return libvlc.dll proc adress
  function VLCGetProcAddress(Name:pchar; var addr:pointer):longbool;
  // return (and clear) last VLD error
  function VLCLastError:integer;


////////////////////////////////////////////////////////////////////////////////
///
///
///
///
////////////////////////////////////////////////////////////////////////////////




implementation


uses
  registry, Sysutils;

var
  LibVLCHandle: THandle = 0;
  LibPath: string;
  LastError: integer = VLD_SUCCESS;
  VLCLibLoaded: boolean = false;

function getLibPath: boolean;
var
  Reg: TRegistry;
begin
  Result := False;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('Software\VideoLAN\VLC') then
    begin
      libPath:=Reg.ReadString('InstallDir')+'\';
      Result:=True;
    end;
  finally
    Reg.Free;
  end;
end;

function VLCLibPath: string;
begin
  if LibPath = '' then
    getLibPath;
  Result := LibPath;
end;

function VLCLoadLibrary:LongBool;
begin
  if LibVLCHandle = 0 then
  begin
    libvlcHandle := LoadLibraryEx(LibName,0,LOAD_WITH_ALTERED_SEARCH_PATH);
    if (libvlcHandle = 0) and (getLibPath) then
    begin
      libvlcHandle := LoadLibraryEx(pchar(libPath + libName),0,LOAD_WITH_ALTERED_SEARCH_PATH);
    end;
  end;

  if LibVLCHandle <> 0 then
  begin
    //VLCGetProcAddress('libvlc_errmsg',@libvlc_errmsg);
    VLCGetProcAddress('libvlc_get_version',@libvlc_get_version);

    Result := Longbool(VLD_SUCCESS)
  end
  else
  begin
    LastError := VLD_NOLIB;
    Result := longbool(LastError);
  end;
end;

procedure VLCUnloadLibrary;
begin
  if LibVLCHandle <> 0 then
    FreeLibrary(LibVLCHandle);
end;

function VLCGetProcAddress(Name: PChar; var Addr: Pointer): LongBool;
begin
  Result:=True;
  if Assigned(Addr) then Exit;


  if LibVLCHandle = 0 then
  begin
    Result := VLCLoadLibrary;
    if Result <> longbool(VLD_SUCCESS) then exit;
  end;

  Addr := GetProcAddress(LibVLCHandle, Name);
  if Addr <> nil then
    Result := longbool(VLD_SUCCESS)
  else
  begin
    LastError := VLD_NOTFOUND;
    Result := longbool(LastError);
  end;
end;

function VLCLastError: Integer;
begin
 Result := LastError;
 LastError := VLD_SUCCESS;
end;



end.
