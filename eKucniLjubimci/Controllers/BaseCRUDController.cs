using Azure.Identity;
using eKucniLjubimci.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Metadata.Conventions;

namespace eKucniLjubimci.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BaseCRUDController<T, TSearch, TAdd, TUpdate> : BaseController<T, TSearch> where TSearch : class
    {
        IBaseServiceCRUD<T, TSearch,TAdd,TUpdate> _service;
        public BaseCRUDController(IBaseServiceCRUD<T, TSearch, TAdd, TUpdate> service) : base(service)
        {
            _service = service;
        }

        [HttpPost]
        public virtual async Task<T> Add([FromBody]TAdd addRequest)
        {
            return await _service.Add(addRequest);
        }

        [HttpPut("{id}")]
        public virtual async Task<T> Update(int id, [FromBody] TUpdate updateRequest)
        {
            return await _service.Update(id,updateRequest);
        }
    }
}
