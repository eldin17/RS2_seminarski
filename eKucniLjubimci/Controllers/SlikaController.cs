using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Services.Database;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace eKucniLjubimci.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SlikaController : ControllerBase
    {
        DataContext _context;
        IMapper _mapper;

        public SlikaController(DataContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        [HttpGet("getByArtikalId/{artikalId}")]
        public async Task<List<DtoSlika>> GetByArtikalId(int artikalId)
        {
            var data = await _context.Slike.Where(x => x.ArtikalId == artikalId).ToListAsync();
            return _mapper.Map<List<DtoSlika>>(data);
        }
        [HttpGet("getByZivotinjaId/{zivotinjaId}")]
        public async Task<List<DtoSlika>> GetByZivotinjaId(int zivotinjaId)
        {
            var data = await _context.Slike.Where(x => x.ZivotinjaId == zivotinjaId).ToListAsync();
            return _mapper.Map<List<DtoSlika>>(data);
        }
    }
}
