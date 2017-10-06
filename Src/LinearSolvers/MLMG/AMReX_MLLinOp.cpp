
#include <AMReX_MLLinOp.H>

namespace amrex {

MLLinOp::MLLinOp (const Vector<Geometry>& a_geom,
                  const Vector<BoxArray>& a_grids,
                  const Vector<DistributionMapping>& a_dmap)
{
    define(a_geom, a_grids, a_dmap);
}

void
MLLinOp::define (const Vector<Geometry>& a_geom,
                 const Vector<BoxArray>& a_grids,
                 const Vector<DistributionMapping>& a_dmap)
{
    m_num_amr_levels = a_geom.size();

    m_amr_ref_ratio.resize(m_num_amr_levels);
    m_num_mg_levels.resize(m_num_amr_levels);

    m_geom.resize(m_num_amr_levels);
    m_grids.resize(m_num_amr_levels);
    m_dmap.resize(m_num_amr_levels);

    // fine amr levels
    for (int amrlev = m_num_amr_levels-1; amrlev > 0; --amrlev)
    {
        m_num_mg_levels[amrlev] = 1;
        m_geom[amrlev].push_back(a_geom[amrlev]);
        m_grids[amrlev].push_back(a_grids[amrlev]);
        m_dmap[amrlev].push_back(a_dmap[amrlev]);

        int rr = 2;
        const Box& dom = a_geom[amrlev].Domain();
        for (int i = 0; i < 30; ++i)
        {
            if (!dom.coarsenable(rr)) amrex::Abort("MLLinOp: Uncoarsenable domain");

            ++(m_num_mg_levels[amrlev]);

            const Box& cdom = amrex::coarsen(dom,rr);
            m_geom[amrlev].emplace_back(cdom);

            m_grids[amrlev].push_back(a_grids[amrlev]);
            AMREX_ASSERT(m_grids[amrlev].back().coarsenable(rr));
            m_grids[amrlev].back().coarsen(rr);

            m_dmap[amrlev].push_back(a_dmap[amrlev]);

            if (cdom == a_geom[amrlev-1].Domain()) break;
            rr *= 2;
        }

        m_amr_ref_ratio[amrlev-1] = rr;
    }

    const int min_width = 2;

    // coarsest amr level
    m_num_mg_levels[0] = 1;
    m_geom[0].push_back(a_geom[0]);
    m_grids[0].push_back(a_grids[0]);
    m_dmap[0].push_back(a_dmap[0]);

    int rr = 2;
    while (a_geom[0].Domain().coarsenable(rr)
           and a_grids[0].coarsenable(rr, min_width))
    {
        ++(m_num_mg_levels[0]);

        m_geom[0].emplace_back(amrex::coarsen(a_geom[0].Domain(),rr));

        m_grids[0].push_back(a_grids[0]);
        m_grids[0].back().coarsen(rr);

        m_dmap[0].push_back(a_dmap[0]);
        
        rr *= 2;
    }
}

MLLinOp::~MLLinOp ()
{}

}
