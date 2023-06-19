using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eKucniLjubimci.Services.Migrations
{
    /// <inheritdoc />
    public partial class ispravka : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "StateMachine",
                table: "KorisnickiNalozi");

            migrationBuilder.AddColumn<bool>(
                name: "isDeleted",
                table: "KorisnickiNalozi",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "isDeleted",
                table: "KorisnickiNalozi");

            migrationBuilder.AddColumn<string>(
                name: "StateMachine",
                table: "KorisnickiNalozi",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }
    }
}
