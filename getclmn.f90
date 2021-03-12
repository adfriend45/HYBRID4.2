!======================================================================!
subroutine getclmn

!----------------------------------------------------------------------!
! Assigns climate variables from global arrays.
! Computes derived climate values.
! Accumulates degree-days.
! Computes temperature factors.
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
use shared
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
implicit none
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Temperature response function.
!----------------------------------------------------------------------!
real :: tfact
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Air temperature                                                    (K)
!----------------------------------------------------------------------!
tairK = tmp (i,j,it)
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Air temperature                                                   (oC)
!----------------------------------------------------------------------!
tair = tairK - tf
!----------------------------------------------------------------------!
     
!----------------------------------------------------------------------!
! Downwelling solar radiation                                    (W m-2)
!----------------------------------------------------------------------!
radsw = dswrf (i,j,it) / dt
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Downwelling PAR                                 (mol[photons] m-2 s-1)
!----------------------------------------------------------------------!
radpar = 2.3e-6 * radsw
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Precipitation                                                 (m dt-1)
!----------------------------------------------------------------------!
ppt = pre (i,j,it) / 1.0e3
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Vapour pressure                                                   (Pa)
!----------------------------------------------------------------------!
vap = pres (i,j,it) * spfh (i,j,it) * r_air_water
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Vapour pressure                                                  (hPa)
!----------------------------------------------------------------------!
vapr = vap / 100.0
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Accumulate degree-days                                            (oC)
!----------------------------------------------------------------------!
if (tair > thold) dd (i,j) = dd (i,j) + (tair - thold) * dt / sday
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Soil temperature, 24-hr minimum temperature (oC).
! Slight trick on first day to avoid carry-over requirement
! from previous year!****adf.
!----------------------------------------------------------------------!
if (it > 3) then
 tsoil = sum (tmp (i,j,it-3:it)) / 4.0 - tf
 tmind = minval (tmp (i,j,it-3:it)) - tf
else
 tsoil = sum (tmp (i,j,1:it)) / float (it) - tf
 tmind = minval (tmp (i,j,1:it)) - tf
end if
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Temperature response function.
!----------------------------------------------------------------------!
tfact = exp (-6595.0 / tairK)
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Dark respiration temperature effect.
!----------------------------------------------------------------------!
if (radpar <= eps) then
 tfaca1 = -42.6e3 * tfact
else
 tfaca1 = zero
end if
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Structure respiration temperature effect.
!----------------------------------------------------------------------!
tfaca2 = -83.14 * tfact
!----------------------------------------------------------------------!
     
!----------------------------------------------------------------------!
! Fine root respiration temperature effect.
!----------------------------------------------------------------------!
tfacs  = -42.6e3 * exp (-6595.0 / (tsoil + tf))
!----------------------------------------------------------------------!

!----------------------------------------------------------------------!
! Atmospheric pressure                                              (Pa) 
!----------------------------------------------------------------------!  
P_Pa = pres (i,j,it)
!----------------------------------------------------------------------!

end subroutine getclmn
!======================================================================!

