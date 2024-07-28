CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Booksuppl FOR NUMBERING
      IMPORTING entities FOR CREATE Booking\_Booksuppl.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Booksuppl.

    DATA: lv_id_max TYPE /dmo/booking_supplement_id  .

    READ ENTITIES OF zpnc_travel IN LOCAL MODE
    ENTITY Booking
    BY \_Booksuppl
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_booking_suppl).

    LOOP AT lt_booking_suppl INTO DATA(ls_booking_suppl).
      IF lv_id_max < ls_booking_suppl-target-BookingSupplementId.
        lv_id_max = ls_booking_suppl-target-BookingSupplementId.
      ENDIF.
    ENDLOOP.

LOOP AT entities INTO DATA(ls_entity).
LOOP AT ls_entity-%target INTO DATA(ls_target).
APPEND CORRESPONDING #( ls_target ) to mapped-booksuppl
    ASSIGNING FIELD-SYMBOL(<lfs_mapped>).
    lv_id_max += 1.
    <lfs_mapped>-BookingSupplementId = lv_id_max.
endloop.
ENDLOOP.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
