REM install python 3.12
REM install cuda 12.8
git clone https://github.com/comfyanonymous/ComfyUI.git
cd .\ComfyUI\custom_nodes
git clone https://github.com/Comfy-Org/ComfyUI-Manager.git
cd ..
python -m venv venv
call .\venv\Scripts\activate
pip install -r .\custom_nodes\ComfyUI-Manager\requirements.txt
pip install -r requirements.txt
cd ..
cd whl
pip install flash_attn-2.8.3+cu128torch2.9.0cxx11abiTRUE-cp312-cp312-win_amd64.whl
pip install insightface-0.7.3-cp312-cp312-win_amd64.whl
pip install nunchaku-1.0.2+torch2.9-cp312-cp312-win_amd64.whl
pip install sageattention-2.2.0+cu128torch2.9.0cxx11abi1-cp312-cp312-win_amd64.whl
pip install spas_sage_attn-0.1.0+cu128torch2.9.0.post3-cp39-abi3-win_amd64.whl
pip install torch==2.9.0 torchvision==0.24.0 torchaudio==2.9.0 --index-url https://download.pytorch.org/whl/cu128
pip install triton-windows
pip install numpy==1.26.4
pause
