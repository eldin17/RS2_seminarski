using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Model.Requests;
using eKucniLjubimci.Model.SearchObjects;
using eKucniLjubimci.Services.Database;
using eKucniLjubimci.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;

namespace eKucniLjubimci.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KorisnickiNalogController :ControllerBase
    {
        DataContext _context;
        IMapper _mapper;
        IConfiguration _configuration;
        public KorisnickiNalogController(DataContext context, IMapper mapper, IConfiguration configuration)
        {
            _context = context;
            _mapper = mapper;
            _configuration = configuration;
        }

        [HttpGet]
        public async Task<ActionResult<List<DtoKorisnickiNalog>>> GetAll()
        {
            var list = await _context.KorisnickiNalozi.Where(x => x.isDeleted ==false).Include(x => x.Uloga).ToListAsync();
            
            var listDto = _mapper.Map<List<DtoKorisnickiNalog>>(list);
            
            return Ok(listDto);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<DtoKorisnickiNalog>> GetById(int id)
        {
            var dbNalog = await _context.KorisnickiNalozi.Where(x => x.isDeleted == false).Include(x=>x.Uloga).FirstOrDefaultAsync(x => x.KorisnickiNalogId == id);

            if (dbNalog == null)
                return BadRequest("Greska! - Korisnicki nalog nije pronadjen");

            var dbNalogDto=_mapper.Map<DtoKorisnickiNalog>(dbNalog);

            return Ok(dbNalogDto);
        }

        [HttpPost("register")]
        public async Task<ActionResult<DtoKorisnickiNalog>> Register(AddKorisnickiNalog obj)
        {
            CreatePasswordHash(obj.Password, out byte[] pwHash, out byte[] pwSalt);

            var novi = new KorisnickiNalog()
            {
                Username = obj.Username,
                PasswordHash = pwHash,
                PasswordSalt = pwSalt,
                UlogaId= obj.UlogaId,
                DatumRegistracije= obj.DatumRegistracije,
            };

            _context.KorisnickiNalozi.Add(novi);
            await _context.SaveChangesAsync();

            var noviDto=_mapper.Map<DtoKorisnickiNalog>(novi);

            return Ok(noviDto);
        }

        private void CreatePasswordHash(string pw, out byte[] pwHash, out byte[] pwSalt)
        {
            using (var hmac = new HMACSHA512())
            {
                pwSalt = hmac.Key;
                pwHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(pw));
            }
        }

        [HttpPost("login")]
        public async Task<ActionResult<DtoLogin>> Login(LoginRequest obj)
        {
            if (obj == null || obj.Username == "" || obj.Password == "" || obj.Username == null || obj.Password == null)
            {
                return BadRequest("No input");
            }
            var izbaze = _context.KorisnickiNalozi.Where(x => x.isDeleted == false).Include(x=>x.Uloga).Single(x => x.Username == obj.Username);
            if (izbaze.Username != obj.Username)
            {
                return BadRequest("Korisničko ime ili lozinka nisu ispravni!");
            }

            if (!VerifyPasswordHash(obj.Password, izbaze.PasswordHash, izbaze.PasswordSalt))
            {
                return BadRequest("Korisničko ime ili lozinka nisu ispravni!");
            }

            string token = CreateToken(izbaze);

            var logiraniKorisnik = new DtoLogin
            {
                Token = token,
                IdLogiranogKorisnika = izbaze.KorisnickiNalogId,
                UlogaNaziv = izbaze.Uloga.Naziv,
            };

            return Ok(logiraniKorisnik);
        }

        private bool VerifyPasswordHash(string pw, byte[] pwHash, byte[] pwSalt)
        {
            using (var hmac = new HMACSHA512(pwSalt))
            {
                var computedHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(pw));
                return computedHash.SequenceEqual(pwHash);
            }
        }

        private string CreateToken(KorisnickiNalog user)
        {
            List<Claim> claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, user.Username),
                new Claim(ClaimTypes.Role, user.Uloga.Naziv)
            };

            var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(
                _configuration.GetSection("AppSettings:Token").Value));

            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);

            var token = new JwtSecurityToken(
                claims: claims,
                expires: DateTime.Now.AddDays(1),
                signingCredentials: creds);

            var jwt = new JwtSecurityTokenHandler().WriteToken(token);

            return jwt;
        }
    }
}
