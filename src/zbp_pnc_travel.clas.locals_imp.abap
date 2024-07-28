CLASS lhc_zpnc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zpnc_travel RESULT result.
    METHODS copy_travel FOR MODIFY
      IMPORTING keys FOR ACTION travel~copy_travel.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE travel.

    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE travel\_booking.

ENDCLASS.

CLASS lhc_zpnc_travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    LOOP AT entities INTO DATA(ls_entity) WHERE TravelId IS NOT INITIAL.
      APPEND CORRESPONDING #( ls_entity ) TO mapped-travel.
    ENDLOOP.

    DATA(lt_travel) = entities.
    DELETE lt_travel WHERE TravelId IS NOT INITIAL.

    cl_numberrange_runtime=>number_get(
      EXPORTING
        nr_range_nr       = '01'
        object            = '/DMO/TRAVL'
        quantity          = CONV #( lines( lt_travel ) )
      IMPORTING
        number            = DATA(lv_number)
        returncode        = DATA(lv_returncode)
        returned_quantity = DATA(lv_returned_quantity)
    ).

    DATA(lv_treval) = lv_number - lv_returned_quantity.
    LOOP AT lt_travel INTO ls_entity.
      lv_treval = lv_treval + 1.
      ls_entity-TravelId = lv_treval.
      APPEND VALUE #( %cid = ls_entity-%cid %key = ls_entity-%key ) TO mapped-travel.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.
    DATA: lv_booking_id_max TYPE /dmo/booking_id.
    READ ENTITIES OF zpnc_travel IN LOCAL MODE
    ENTITY Travel
    BY \_Booking
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_booking).

    LOOP AT lt_booking INTO DATA(ls_booking).
      IF lv_booking_id_max < ls_booking-target-BookingId.
        lv_booking_id_max = ls_booking-target-BookingId.
      ENDIF.
    ENDLOOP.

    LOOP AT entities INTO DATA(ls_entity) GROUP BY ls_entity-TravelId.
      LOOP AT ls_entity-%target INTO DATA(ls_target).
        APPEND CORRESPONDING #( ls_target ) TO mapped-booking ASSIGNING FIELD-SYMBOL(<lfs_booking>).
        <lfs_booking>-BookingId = lv_booking_id_max + 10.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD copy_travel.

  READ TABLE keys INDEX 1 INTO DATA(key).

  ENDMETHOD.

ENDCLASS.
