CLASS zcx_rap_event_hdlr_error_retry DEFINITION
  PUBLIC
  INHERITING FROM cx_rap_event_hdlr_error_retry
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !textid     LIKE if_t100_message=>t100key
        !previous   LIKE previous OPTIONAL
        !delay_time TYPE ty_delay_time .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_RAP_EVENT_HDLR_ERROR_RETRY IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(
    textid = textid
    previous = previous
    delay_time = delay_time
    ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
