@EndUserText.label: 'Booking Supplement Projectioin'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity zpnc_c_booksuppl
  as projection on zpnc_booksuppl
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      SupplementId,
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _Booking: redirected to parent zpnc_c_booking,
      _Product,
      _SupplementText,
      _Travel: redirected to zpnc_c_travel
}
