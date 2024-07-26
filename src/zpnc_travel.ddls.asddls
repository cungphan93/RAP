@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Model'
define root view entity zpnc_travel
  as select from /dmo/travel_m
  composition [0..*] of zpnc_booking             as _Booking
  association [1]    to /DMO/I_Agency               as _Agency     on $projection.AgencyId = _Agency.AgencyID
  association [1]    to /DMO/I_Customer             as _Customer   on $projection.CustomerId = _Customer.CustomerID
  association [1]    to I_Currency                  as _Currency   on $projection.CurrencyCode = _Currency.Currency
  association [1..1] to /DMO/I_Overall_Status_VH as _OverallStatus on $projection.OverallStatus = _OverallStatus.OverallStatus
{
  key /dmo/travel_m.travel_id       as TravelId,
      /dmo/travel_m.agency_id       as AgencyId,
      /dmo/travel_m.customer_id     as CustomerId,
      /dmo/travel_m.begin_date      as BeginDate,
      /dmo/travel_m.end_date        as EndDate,
      /dmo/travel_m.booking_fee     as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      /dmo/travel_m.total_price     as TotalPrice,
      /dmo/travel_m.currency_code   as CurrencyCode,
      /dmo/travel_m.description     as Description,
      /dmo/travel_m.overall_status  as OverallStatus,
      @Semantics.user.createdBy: true
      /dmo/travel_m.created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      /dmo/travel_m.created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      /dmo/travel_m.last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      /dmo/travel_m.last_changed_at as LastChangedAt,
    case overall_status
        when 'O' then 'Open'
        when 'A' then 'Approved'
        when 'R' then 'Rejected'
        when 'X' then 'Cancelled'
        end as StatusText,
    case overall_status
        when 'O' then 2
        when 'A' then 3
        when 'R' then 1
        when 'X' then 1
        end as Criticality,
      _Booking,
      _Agency, // Make association public
      _Customer,
      _Currency,
      _OverallStatus
}
