CLASS lhc_ZMaterialBOMItemAdd DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZMaterialBOMItemAdd RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ZMaterialBOMItemAdd RESULT result.

ENDCLASS.

CLASS lhc_ZMaterialBOMItemAdd IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_MATERIALBOMITEMADD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_MATERIALBOMITEMADD IMPLEMENTATION.

  METHOD save_modified.

* Raise Created Event
    IF create-zmaterialbomitemadd IS NOT INITIAL.
      RAISE ENTITY EVENT zr_materialbomitemaddtp~Created
          FROM VALUE #( FOR <instance> IN create-zmaterialbomitemadd ( %key = <instance>-%key ) ).
    ENDIF.

* Raise Changed Event
    IF update-zmaterialbomitemadd IS NOT INITIAL.
      RAISE ENTITY EVENT zr_materialbomitemaddtp~Changed
          FROM VALUE #( FOR <instance> IN create-zmaterialbomitemadd ( %key = <instance>-%key ) ).
    ENDIF.

* Raise Deleted Event and filled with parameter
    IF delete-zmaterialbomitemadd IS NOT INITIAL.
      RAISE ENTITY EVENT zr_materialbomitemaddtp~Deleted
          FROM VALUE #( FOR <instance> IN create-zmaterialbomitemadd ( %key = <instance>-%key
                                                                      %param-CreatedAt = <instance>-CreatedAt
                                                                      %param-CreatedBy = <instance>-CreatedBy
                                                                      %param-LastChangedAt = <instance>-LastChangedAt
                                                                      %param-LastChangedBy = <instance>-LastChangedBy
                                                                      %param-LocalLastChangedAt = <instance>-LocalLastChangedAt ) ).
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
