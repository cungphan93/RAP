CLASS zpnc_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .

    CLASS-METHODS get_data
      IMPORTING
        VALUE(iv_id)    TYPE zheena_travel-agency_id
      EXPORTING
        VALUE(et_table) TYPE zpnc_tt_travel.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpnc_amdp IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    get_data(
      EXPORTING
        iv_id    = '070041'
      IMPORTING
        et_table = DATA(lt_data)
    ).

    out->write(  EXPORTING data   = lt_data ).

  ENDMETHOD.


  METHOD get_data BY DATABASE PROCEDURE
                     FOR HDB
                     LANGUAGE SQLSCRIPT
                     OPTIONS READ-ONLY
                     USING zheena_travel.

    DECLARE lv_count INTEGER;
    DECLARE lv_price DECIMAL;
    DECLARE i INTEGER;
    lt_data = SELECT * FROM zheena_travel WHERE agency_id = :iv_id;

    lv_count := record_count( :lt_data );
    FOR i in 1..:lv_count do
     if :lt_data.total_price[i] > 1000 THEN
     lv_price := :lt_data.total_price[i] * 0.9;
     end if;

     :et_table.insert( (
      :lt_data.client[i],
      :lt_data.travel_uuid[i],
      :lt_data.travel_id[i],
      :lt_data.agency_id[i],
      :lt_data.customer_id[i],
      :lt_data.begin_date[i],
      :lt_data.end_date[i],
      :lt_data.booking_fee[i],
      :lv_price,
      :lt_data.currency_code[i],
      :lt_data.description[i],
      :lt_data.overall_status[i],
      :lt_data.created_by[i],
      :lt_data.created_at[i],
      :lt_data.last_changed_by[i],
      :lt_data.last_changed_at[i],
      :lt_data.local_last_changed_at[i] ), i
     );
    end for ;
  ENDMETHOD.

ENDCLASS.
