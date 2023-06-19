using AutoMapper;
using eKucniLjubimci.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.ArtikalStateMachine
{
    public class DeletedArtikalState : BaseArtikalState
    {
        public DeletedArtikalState(DataContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
    }
}
