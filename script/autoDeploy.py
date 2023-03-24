import asyncio
import subprocess
import time


def get_time():
    current_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
    return current_time


async def run_command(cmd):
    process = await asyncio.create_subprocess_shell(
        cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE
    )
    stdout, stderr = await process.communicate()
    if len(stdout) != 0:
        print(f"[{get_time()}] Success: {stdout.decode()}")
    elif len(stderr) != 0:
        print(f"[{get_time()}] Error: {stderr.decode()}")
    else:
        pass

    return stdout, stderr


async def main():
    print(f"[{get_time()}] Start to compile")
    print("\t")
    await run_command("solcjs --base-path ./  ./contracts/DataUsageContract.sol --abi --bin -o build")
    await run_command("solcjs --base-path ./  ./contracts/AgreementContract.sol --abi --bin -o build")
    await run_command("solcjs --base-path ./  ./contracts/LogContract.sol --abi --bin -o build")
    await run_command("solcjs --base-path ./  ./contracts/VerificationContract.sol --abi --bin -o build")
    print(f"[{get_time()}] End of compilation")
    print("\t")
    print(f"[{get_time()}] Start to deploy\t")
    print("\t")
    await run_command("node ./script/DataUsageDeploy.js")
    await run_command("node ./script/AgreementDeploy.js")
    await run_command("node ./script/LogContractDeploy.js")
    await run_command("node ./script/VerificationDeploy.js")
    print(f"[{get_time()}] End of deployment")
    print("\t")


asyncio.run(main())
