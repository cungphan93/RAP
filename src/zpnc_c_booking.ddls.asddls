@EndUserText.label: 'Booking Supplement Projectioin'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity zpnc_c_booking
  as projection on zpnc_booking
{
  key TravelId,
  key BookingId,
      BookingDate,
      CustomerId,
      CarrierId,
      ConnectionId,
      FlightDate,
      FlightPrice,
      CurrencyCode,
      BookingStatus,
      LastChangedAt,
      /* Associations */
      _BookingStatus,
      _Booksuppl: redirected to composition child zpnc_c_booksuppl,
      _Carrier,
      _Connection,
      _Customer,
      _Travel: redirected to parent zpnc_c_travel
}
