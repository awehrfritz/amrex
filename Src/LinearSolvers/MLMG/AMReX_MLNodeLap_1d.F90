module amrex_mlnodelap_1d_module

  use amrex_fort_module, only : amrex_real
  implicit none

  private
  public :: amrex_mlndlap_avgdown_coeff, amrex_mlndlap_fillbc_coeff, amrex_mlndlap_divu, &
       amrex_mlndlap_applybc, amrex_mlndlap_adotx, amrex_mlndlap_jacobi, amrex_mlndlap_gauss_seidel, &
       amrex_mlndlap_restriction, amrex_mlndlap_interpolation, amrex_mlndlap_mknewu

contains

  subroutine amrex_mlndlap_avgdown_coeff (lo, hi, crse, clo, chi, fine, flo, fhi, idim) &
       bind(c,name='amrex_mlndlap_avgdown_coeff')
    integer, dimension(3), intent(in) :: lo, hi, clo, chi, flo, fhi
    integer, intent(in) :: idim
    real(amrex_real), intent(inout) :: crse(clo(1):chi(1),clo(2):chi(2),clo(3):chi(3))
    real(amrex_real), intent(in   ) :: fine(flo(1):fhi(1),flo(2):fhi(2),flo(3):fhi(3))
  end subroutine amrex_mlndlap_avgdown_coeff


  subroutine amrex_mlndlap_fillbc_coeff (sigma, slo, shi, dlo, dhi) &
       bind(c, name='amrex_mlndlap_fillbc_coeff')
    integer, dimension(2), intent(in) :: slo, shi, dlo, dhi
    real(amrex_real), intent(inout) :: sigma(slo(1):shi(1),slo(2):shi(2))
    
  end subroutine amrex_mlndlap_fillbc_coeff


  subroutine amrex_mlndlap_divu (lo, hi, rhs, rlo, rhi, vel, vlo, vhi, dxinv) &
       bind(c,name='amrex_mlndlap_divu')
    integer, dimension(1), intent(in) :: lo, hi, rlo, rhi, vlo, vhi
    real(amrex_real), intent(in) :: dxinv(2)
    real(amrex_real), intent(inout) :: rhs(rlo(1):rhi(1))
    real(amrex_real), intent(in   ) :: vel(vlo(1):vhi(1))
  end subroutine amrex_mlndlap_divu


  subroutine amrex_mlndlap_mknewu (lo, hi, u, ulo, uhi, p, plo, phi, sig, slo, shi, dxinv) &
       bind(c,name='amrex_mlndlap_mknewu')
    integer, dimension(2), intent(in) :: lo, hi, ulo, uhi, plo, phi, slo, shi
    real(amrex_real), intent(in) :: dxinv(2)
    real(amrex_real), intent(inout) ::   u(ulo(1):uhi(1),ulo(2):uhi(2),2)
    real(amrex_real), intent(in   ) ::   p(plo(1):phi(1),plo(2):phi(2))
    real(amrex_real), intent(in   ) :: sig(slo(1):shi(1),slo(2):shi(2))
  end subroutine amrex_mlndlap_mknewu


  subroutine amrex_mlndlap_applybc (phi, hlo, hhi, dlo, dhi, bclo, bchi) &
       bind(c,name='amrex_mlndlap_applybc')
    integer, dimension(2) :: hlo, hhi, dlo, dhi, bclo, bchi
    real(amrex_real), intent(inout) :: phi(hlo(1):hhi(1),hlo(2):hhi(2))
    
  end subroutine amrex_mlndlap_applybc


  subroutine amrex_mlndlap_adotx (lo, hi, y, ylo, yhi, x, xlo, xhi, &
       sx, sxlo, sxhi, sy, sylo, syhi, dxinv) bind(c,name='amrex_mlndlap_adotx')
    integer, dimension(2), intent(in) :: lo, hi, ylo, yhi, xlo, xhi, sxlo, sxhi, sylo, syhi
    real(amrex_real), intent(in) :: dxinv(2)
    real(amrex_real), intent(inout) ::  y( ylo(1): yhi(1), ylo(2): yhi(2))
    real(amrex_real), intent(in   ) ::  x( xlo(1): xhi(1), xlo(2): xhi(2))
    real(amrex_real), intent(in   ) :: sx(sxlo(1):sxhi(1),sxlo(2):sxhi(2))
    real(amrex_real), intent(in   ) :: sy(sylo(1):syhi(1),sylo(2):syhi(2))
    
    integer :: i,j
!    real(amrex_real) :: dhx, dhy

  end subroutine amrex_mlndlap_adotx  


  subroutine amrex_mlndlap_jacobi (lo, hi, sol, slo, shi, Ax, alo, ahi, rhs, rlo, rhi, &
       sx, sxlo, sxhi, dxinv) bind(c,name='amrex_mlndlap_jacobi')
    integer, dimension(1),intent(in) :: lo,hi,slo,shi,alo,ahi,rlo,rhi,sxlo,sxhi
    real(amrex_real), intent(in) :: dxinv(1)
    real(amrex_real), intent(inout) :: sol( slo(1): shi(1))
    real(amrex_real), intent(in   ) :: Ax ( alo(1): ahi(1))
    real(amrex_real), intent(in   ) :: rhs( rlo(1): rhi(1))
    real(amrex_real), intent(in   ) :: sx (sxlo(1):sxhi(1))
    
  end subroutine amrex_mlndlap_jacobi


  subroutine amrex_mlndlap_gauss_seidel (lo, hi, sol, slo, shi, rhs, rlo, rhi, &
       sx, sxlo, sxhi, sy, sylo, syhi, dxinv, domlo, domhi, bclo, bchi) &
       bind(c,name='amrex_mlndlap_gauss_seidel')
    integer, dimension(2),intent(in) :: lo,hi,slo,shi,rlo,rhi,sxlo,sxhi,sylo,syhi, &
         domlo, domhi, bclo, bchi
    real(amrex_real), intent(in) :: dxinv(2)
    real(amrex_real), intent(inout) :: sol( slo(1): shi(1), slo(2): shi(2))
    real(amrex_real), intent(in   ) :: rhs( rlo(1): rhi(1), rlo(2): rhi(2))
    real(amrex_real), intent(in   ) :: sx (sxlo(1):sxhi(1),sxlo(2):sxhi(2))
    real(amrex_real), intent(in   ) :: sy (sylo(1):syhi(1),sylo(2):syhi(2))
  end subroutine amrex_mlndlap_gauss_seidel


  subroutine amrex_mlndlap_restriction (lo, hi, crse, clo, chi, fine, flo, fhi, dlo, dhi, bclo, bchi) &
       bind(c,name='amrex_mlndlap_restriction')
    integer, dimension(2), intent(in) :: lo, hi, clo, chi, flo, fhi, dlo, dhi, bclo, bchi
    real(amrex_real), intent(inout) :: crse(clo(1):chi(1),clo(2):chi(2))
    real(amrex_real), intent(in   ) :: fine(flo(1):fhi(1),flo(2):fhi(2))
  end subroutine amrex_mlndlap_restriction


  subroutine amrex_mlndlap_interpolation (clo, chi, flo, fhi, fine, fflo, ffhi, crse, cflo, cfhi, &
       sx, sxlo, sxhi, sy, sylo, syhi) bind(c,name='amrex_mlndlap_interpolation')
    integer, dimension(2), intent(in) :: clo,chi,flo,fhi,fflo,ffhi,cflo,cfhi,sxlo,sxhi,sylo,syhi
    real(amrex_real), intent(in   ) :: crse(cflo(1):cfhi(1),cflo(2):cfhi(2))
    real(amrex_real), intent(inout) :: fine(fflo(1):ffhi(1),fflo(2):ffhi(2))
    real(amrex_real), intent(in   ) :: sx  (sxlo(1):sxhi(1),sxlo(2):sxhi(2))
    real(amrex_real), intent(in   ) :: sy  (sylo(1):syhi(1),sylo(2):syhi(2))

  end subroutine amrex_mlndlap_interpolation


end module amrex_mlnodelap_1d_module