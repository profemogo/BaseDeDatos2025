CALL RegistrarPacienteCompleto(
    -- ===== DATOS BÁSICOS =====
    '28131999',           -- Documento/Cédula
    1,                     -- Tipo documento (1=Cédula)
    2,                     -- Estado civil (2=Casada)
    'María José',          -- Nombre
    'Pérez Zambrano',      -- Apellido
    '1988-07-19',         -- Fecha de nacimiento
    'Bachiller',          -- Estudios
    'Av. Amazonas N45-12', -- Dirección
    
    -- ===== HÁBITOS =====
    FALSE,                 -- Consume alcohol (No)
    FALSE,                 -- Fuma tabaco (No) 
    TRUE,                  -- Consume café (Sí)
    
    -- ===== EXAMEN FÍSICO =====
    'Mamas simétricas, sin nódulos palpables', -- Examen de mama
    '2023-10-15: Hallazgos normales',         -- Colposcopia
    
    -- ===== ANTECEDENTE FAMILIAR =====
    'Madre: Diabetes tipo 2. Abuela materna: Cáncer de mama a los 65 años',
    
    -- ===== ANTECEDENTE PERSONAL =====
    4,                     -- Tipo de sangre (4='B+')
    'Alergia a sulfas, apendicectomía 2005',
    
    -- ===== ANTECEDENTE OBSTÉTRICO =====
    3,                     -- 3 embarazos (gesta)
    2,                     -- 2 partos vaginales (vag)
    1,                     -- 1 cesárea (cec)
    0,                     -- 0 abortos
    '2023-09-05',         -- FUR (Fecha última menstruación)
    '2024-06-12',         -- FPP (Fecha probable parto)
    
    -- ===== ANTECEDENTE GINECOLÓGICO =====
    'Regular 28/5',       -- Ciclo menstrual (28 días, sangrado 5 días)
    13,                   -- Menarquia a los 13 años  
    NULL,                 -- Menopausia (aún no)
    '2023-09-20',         -- Última citología
    'Negativo para NIC',  -- Resultado citología
    
    -- ===== PARÁMETRO DE SALIDA =====
    @id_paciente_maria    -- Variable para almacenar el ID generado
);