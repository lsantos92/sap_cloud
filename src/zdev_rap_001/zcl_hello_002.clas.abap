CLASS zcl_hello_002 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: tt_carriers TYPE STANDARD TABLE OF /dmo/carrier WITH EMPTY KEY.

    METHODS get_carriers RETURNING VALUE(rt_carriers) TYPE tt_carriers.
ENDCLASS.



CLASS zcl_hello_002 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    out->write( |Hello World!| ).
    out->write( get_carriers( ) ).

  ENDMETHOD.

  METHOD get_carriers.

    SELECT *
    FROM /dmo/carrier
    INTO TABLE @rt_carriers.

  ENDMETHOD.
ENDCLASS.
