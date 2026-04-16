using System.ComponentModel.DataAnnotations;

namespace LabApi.Contracts.Products;

public sealed class CreateProductRequest
{
    [Required]
    [StringLength(200)]
    public string Name { get; set; } = string.Empty;

    [Range(typeof(decimal), "0", "79228162514264337593543950335")]
    public decimal Price { get; set; }
}