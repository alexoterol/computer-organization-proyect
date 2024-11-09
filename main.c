#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// De decimal a binario
void convertirDecimalABinario(int decimal) {
    int binario[8] = {0};
    int indice = 7;
    
    while (decimal > 0 && indice >= 0) {
        binario[indice] = decimal % 2;
        decimal /= 2;
        indice--;
    }
    
    printf("Binario: ");
    for (int i = 0; i < 8; i++) {
        printf("%d", binario[i]);
    }
    printf("\n");
}

// De binario (de 8 bits) a decimal
int convertirBinarioADecimal(char binario[9]) {
    int decimal = 0;
    
    for (int i = 0; i < 8; i++) {
        if (binario[i] == '1') {
            decimal = (decimal << 1) | 1;
        } else if (binario[i] == '0') {
            decimal = decimal << 1;
        } else {
            printf("Error: El número binario debe contener solo '0' o '1'.\n");
            return -1;
        }
    }
    
    return decimal;
}

// Generar un número aleatorio entre 10 y 50 y mostrar su conversión a binario
void generarNumeroAleatorio() {
    srand(time(NULL));
    int numero = rand() % 41 + 10; // Genera número entre 10 y 50
    printf("Número aleatorio: %d\n", numero);
    convertirDecimalABinario(numero);
}

int main() {
    int opcion;
    int numeroDecimal;
    char numeroBinario[9];
    
    do {
        printf("\nMenú:\n");
        printf("1. Convertir Decimal a Binario\n");
        printf("2. Convertir Binario a Decimal\n");
        printf("3. Generar un número aleatorio\n");
        printf("4. Salir\n");
        printf("Seleccione una opción: ");
        scanf("%d", &opcion);

        switch (opcion) {
            case 1:
                printf("Ingrese un número decimal: ");
                scanf("%d", &numeroDecimal);
                if (numeroDecimal >= 0) {
                    convertirDecimalABinario(numeroDecimal);
                } else {
                    printf("Error: Ingrese un número decimal positivo.\n");
                }
                break;
            case 2:
                printf("Ingrese un número binario de 8 bits: ");
                scanf("%s", numeroBinario);
                int resultado = convertirBinarioADecimal(numeroBinario);
                if (resultado != -1) {
                    printf("Decimal: %d\n", resultado);
                }
                break;
            case 3:
                generarNumeroAleatorio();
                break;
            case 4:
                printf("Saliendo del programa.\n");
                break;
            default:
                printf("Opción no válida. Intente de nuevo.\n");
        }
    } while (opcion != 4);
    
    return 0;
}

