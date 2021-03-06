!=============================================================================
! probparams module
!
! The propparams module controls the runtime parameters for the
! problem-specific initial conditions only.  It reads them in from
! the same inputs file as the params module, but looks for a different
! namelist.
!=============================================================================

module probparams_module

  use datatypes_module
  implicit none

  !---------------------------------------------------------------------------
  ! declare runtime parameters with SAVE attribute and default values
  !---------------------------------------------------------------------------

  real (kind=dp_t), save :: pres_base = 1.65e6_dp_t
  real (kind=dp_t), save :: dens_base = 1.65e-3_dp_t
  real (kind=dp_t), save :: small_dens = 1.e-7_dp_t
  

  logical, save :: do_isentropic = .false.

  ! namelist
  namelist /problem/ pres_base, dens_base, small_dens, do_isentropic

contains

  !===========================================================================
  ! init_params
  !===========================================================================
  subroutine init_probparams

    use params_module, only: infile

    integer :: lun, status

    if (.not. infile == "") then

       print *, 'reading problem-specific parameters from ', trim(infile)
       
       open(newunit=lun, file=trim(infile), status="old", action="read")
       read(unit=lun, nml=problem, iostat=status)

       if (status < 0) then
          ! namelist doesn't exist.  Use the defaults and carry on.
          continue

       else if (status > 0) then
          ! some problem with the namelist.
          print *, "ERROR: problem namelist invalid"
          stop

       endif

       close(unit=lun)

    endif    

  end subroutine init_probparams

end module probparams_module
